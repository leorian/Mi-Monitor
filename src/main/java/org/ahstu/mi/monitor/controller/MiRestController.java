package org.ahstu.mi.monitor.controller;

import org.ahstu.mi.common.MiUtil;
import org.ahstu.mi.monitor.enums.ImanagerErrorEnum;
import org.ahstu.mi.monitor.util.ResultMessageBuilder;
import org.ahstu.mi.zk.MiZkClient;
import org.apache.zookeeper.KeeperException;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
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
}
