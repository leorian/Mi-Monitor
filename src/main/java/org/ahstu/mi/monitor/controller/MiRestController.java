package org.ahstu.mi.monitor.controller;

import org.ahstu.mi.common.MiUtil;
import org.ahstu.mi.common.StringUtil;
import org.ahstu.mi.consumer.MiConsumerMeta;
import org.ahstu.mi.module.ServiceMeta;
import org.ahstu.mi.monitor.enums.ImanagerErrorEnum;
import org.ahstu.mi.monitor.util.ImanagerUtil;
import org.ahstu.mi.monitor.util.ResultMessageBuilder;
import org.ahstu.mi.zk.MiZkClient;
import org.apache.zookeeper.KeeperException;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by xiezg@317hu.com on 2017/8/11 0011.
 */
@RestController
@RequestMapping("miRest")
public class MiRestController {
    static {
        try {
            MiZkClient.getInstance().connect("172.16.150.151:2181,172.16.150.151:2182,172.16.150.151:2183");
        } catch (IOException e) {
            e.printStackTrace();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (KeeperException e) {
            e.printStackTrace();
        }
    }

    /**
     * 分组列表
     *
     * @return
     */
    @PostMapping("groupList")
    public String groupList() {
        //分组
        List<String> groupPaths = getChildrenPath(MiUtil.getProviderZkPath());
        if (CollectionUtils.isEmpty(groupPaths)) {
            return ResultMessageBuilder.build(false, ImanagerErrorEnum.E10002.getError(),
                    ImanagerErrorEnum.E10002.getMsg()).
                    toJSONString();
        }

        return ResultMessageBuilder.build(groupPaths).toJSONString();
    }

    /**
     * 服务名列表
     *
     * @param request
     * @return
     */
    @PostMapping("serviceNameList")
    public String serviceNameList(HttpServletRequest request) {
        String groupPath = request.getParameter("group");
        List<String> serviceGroupPaths = getChildrenPath(ImanagerUtil.getProviderGroupPath(groupPath));
        if (CollectionUtils.isEmpty(serviceGroupPaths)) {
            return ResultMessageBuilder.build(false, ImanagerErrorEnum.E10003.getError(),
                    ImanagerErrorEnum.E10003.getMsg()).
                    toJSONString();
        }

        return ResultMessageBuilder.build(serviceGroupPaths).toJSONString();
    }

    /**
     * @param request
     * @return
     */
    @PostMapping("versionList")
    public String versionList(HttpServletRequest request) {
        String groupPath = request.getParameter("group");
        String serviceNamePath = request.getParameter("serviceName");
        //版本
        List<String> versionServiceGroupPaths = getChildrenPath(ImanagerUtil.
                getProviderGroupServiceNamePath(groupPath, serviceNamePath));
        if (CollectionUtils.isEmpty(versionServiceGroupPaths)) {
            return ResultMessageBuilder.build(false, ImanagerErrorEnum.E10004.getError(),
                    ImanagerErrorEnum.E10004.getMsg()).
                    toJSONString();
        }

        return ResultMessageBuilder.build(versionServiceGroupPaths).toJSONString();
    }

    /**
     * 请求参数：{
     * serviceName:服务名，
     * group:组,
     * ip:ip
     * }
     *
     * @param request
     * @return
     */
    @PostMapping("providerList")
    public String providerList(HttpServletRequest request) {
        String serviceName = request.getParameter("serviceName");
        String group = request.getParameter("group");
        String ip = request.getParameter("ip");
        List<ServiceMeta> serviceMetaList = new ArrayList<>();
        //分组
        List<String> groupPaths = getChildrenPath(MiUtil.getProviderZkPath());
        if (CollectionUtils.isEmpty(groupPaths)) {
            return ResultMessageBuilder.build(false, ImanagerErrorEnum.E10002.getError(),
                    ImanagerErrorEnum.E10002.getMsg()).
                    toJSONString();
        }

        //查询条件分组不为空时
        if (StringUtil.isNotBlank(group)) {
            groupPaths = new ArrayList<>();
            groupPaths.add(group.trim());
        }

        for (String groupPath : groupPaths) {
            //服务
            List<String> serviceGroupPaths = getChildrenPath(ImanagerUtil.getProviderGroupPath(groupPath));
            if (CollectionUtils.isEmpty(serviceGroupPaths)) {
                continue;
            }

            //查询条件服务名不为空时
            if (StringUtil.isNotBlank(serviceName)) {
                serviceGroupPaths = new ArrayList<>();
                serviceGroupPaths.add(serviceName.trim());
            }

            for (String serviceGroupPath : serviceGroupPaths) {
                //版本
                List<String> versionServiceGroupPaths = getChildrenPath(ImanagerUtil.
                        getProviderGroupServiceNamePath(groupPath, serviceGroupPath));
                if (CollectionUtils.isEmpty(versionServiceGroupPaths)) {
                    continue;
                }

                for (String versionServiceGroupPath : versionServiceGroupPaths) {
                    //IP端口号
                    List<String> versionServiceGroupPathAndIpPorts = getChildrenPath(ImanagerUtil.
                            getProviderServiceNameGroupVersionZkPath(groupPath, serviceGroupPath, versionServiceGroupPath));
                    if (CollectionUtils.isEmpty(versionServiceGroupPathAndIpPorts)) {
                        continue;
                    }

                    List<String> ipPorts = new ArrayList<>();
                    if (StringUtil.isNotBlank(ip)) {
                        for (String versionServiceGroupPathAndIpPort : versionServiceGroupPathAndIpPorts) {
                            if (versionServiceGroupPathAndIpPort.contains(ip.trim())) {
                                ipPorts.add(versionServiceGroupPathAndIpPort);
                            }
                        }
                        versionServiceGroupPathAndIpPorts = ipPorts;
                    }

                    //节点数据
                    for (String versionServiceGroupPathAndIpPort :
                            versionServiceGroupPathAndIpPorts) {
                        String serviceMetaStr = getPathData(ImanagerUtil.getProviderIpPortPath(groupPath, serviceGroupPath,
                                versionServiceGroupPath, versionServiceGroupPathAndIpPort));
                        if (StringUtil.isNotBlank(serviceMetaStr)) {
                            serviceMetaList.add(MiUtil.jsonToServiceMeta(serviceMetaStr));
                        }

                    }

                }

            }

        }

        return ResultMessageBuilder.build(serviceMetaList).toJSONString();
    }

    /**
     * 请求参数：{
     * serviceName:"服务名",
     * group:组,
     * ip:ip
     * }
     *
     * @param request
     * @return
     */

    @PostMapping("consumerList")
    public String consumerList(HttpServletRequest request) {
        String serviceName = request.getParameter("serviceName");
        String group = request.getParameter("group");
        String ip = request.getParameter("ip");
        List<MiConsumerMeta> insistConsumerMetaList = new ArrayList<>();
        //分组
        List<String> groupPaths = getChildrenPath(MiUtil.getConsumerZkPath());
        if (CollectionUtils.isEmpty(groupPaths)) {
            return ResultMessageBuilder.build(false, ImanagerErrorEnum.E10002.getError(),
                    ImanagerErrorEnum.E10002.getMsg()).
                    toJSONString();
        }

        //查询条件分组不为空时
        if (StringUtil.isNotBlank(group)) {
            groupPaths = new ArrayList<>();
            groupPaths.add(group.trim());
        }

        for (String groupPath : groupPaths) {
            //服务
            List<String> serviceGroupPaths = getChildrenPath(ImanagerUtil.getConsumerGroupPath(groupPath));
            if (CollectionUtils.isEmpty(serviceGroupPaths)) {
                continue;
            }

            //查询条件服务名不为空时
            if (StringUtil.isNotBlank(serviceName)) {
                serviceGroupPaths = new ArrayList<>();
                serviceGroupPaths.add(serviceName.trim());
            }

            for (String serviceGroupPath : serviceGroupPaths) {
                //版本
                List<String> versionServiceGroupPaths = getChildrenPath(ImanagerUtil.
                        getConsumerGroupServiceNamePath(groupPath, serviceGroupPath));
                if (CollectionUtils.isEmpty(versionServiceGroupPaths)) {
                    continue;
                }

                for (String versionServiceGroupPath : versionServiceGroupPaths) {
                    //IP端口号
                    List<String> versionServiceGroupPathAndIpPorts = getChildrenPath(ImanagerUtil.
                            getConsumerServiceNameGroupVersionZkPath(groupPath, serviceGroupPath, versionServiceGroupPath));
                    if (CollectionUtils.isEmpty(versionServiceGroupPathAndIpPorts)) {
                        continue;
                    }

                    if (StringUtil.isNotBlank(ip)) {
                        List<String> ipPorts = new ArrayList<>();
                        for (String versionServiceGroupPathAndIpPort : versionServiceGroupPathAndIpPorts) {
                            if (versionServiceGroupPathAndIpPort.contains(ip)) {
                                ipPorts.add(versionServiceGroupPathAndIpPort);
                            }
                        }

                        versionServiceGroupPathAndIpPorts = ipPorts;
                    }

                    //节点数据
                    for (String versionServiceGroupPathAndIpPort :
                            versionServiceGroupPathAndIpPorts) {
                        String serviceMetaStr = getPathData(ImanagerUtil.getConsumerIpPortPath(groupPath, serviceGroupPath,
                                versionServiceGroupPath, versionServiceGroupPathAndIpPort));
                        if (StringUtil.isNotBlank(serviceMetaStr)) {
                            insistConsumerMetaList.add(MiUtil.jsonToClientMeta(serviceMetaStr));
                        }

                    }

                }

            }

        }
        return ResultMessageBuilder.build(insistConsumerMetaList).toJSONString();
    }

    /**
     * 获取zookeeper连接信息
     *
     * @return
     */
    @PostMapping("zkHosts")
    public String zkHosts() {
        return System.getProperty("insist.zkHosts");
    }


    /**
     * 获取子节点
     *
     * @param baseZkPath
     * @return
     */
    private List<String> getChildrenPath(String baseZkPath) {
        try {
            return MiZkClient.getInstance().getNodeChildren(baseZkPath);
        } catch (Throwable e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * 获取节点数据
     *
     * @param zkPath
     * @return
     */
    private String getPathData(String zkPath) {
        try {
            return MiZkClient.getInstance().getDataForStr(zkPath, -1);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
