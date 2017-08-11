package org.ahstu.mi.monitor.controller;

import com.alibaba.fastjson.JSON;
import org.ahstu.mi.common.MiException;
import org.ahstu.mi.common.MiResult;
import org.ahstu.mi.common.StringUtil;
import org.ahstu.mi.dynamic.MiDynamicCallClient;
import org.ahstu.mi.monitor.enums.ImanagerErrorEnum;
import org.ahstu.mi.monitor.util.ResultMessageBuilder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by xiezg@317hu.com on 2017/8/11 0011.
 */
@RestController
@RequestMapping("js2Mi")
public class Js2MiRpcRestController {
    /**
     * 动态调用
     *
     * @param request
     * @return
     */
    @PostMapping("dynamicCall")
    public String dynamicCall(HttpServletRequest request) {
        String serviceName = request.getParameter("serviceName");
        if (StringUtil.isBlank(serviceName)) {
            return ResultMessageBuilder.build(false, ImanagerErrorEnum.E10005.getError(),
                    ImanagerErrorEnum.E10005.getCnMsg()).toJSONString();
        }
        String group = request.getParameter("group");

        if (StringUtil.isBlank(group)) {
            return ResultMessageBuilder.build(false, ImanagerErrorEnum.E10006.getError(),
                    ImanagerErrorEnum.E10006.getCnMsg()).toJSONString();
        }

        String version = request.getParameter("version");

        if (StringUtil.isBlank(version)) {
            return ResultMessageBuilder.build(false, ImanagerErrorEnum.E10007.getError(),
                    ImanagerErrorEnum.E10007.getCnMsg()).toJSONString();
        }

        String methodName = request.getParameter("methodName");

        if (StringUtil.isBlank(methodName)) {
            return ResultMessageBuilder.build(false, ImanagerErrorEnum.E10008.getError(),
                    ImanagerErrorEnum.E10008.getCnMsg()).toJSONString();
        }


        if (methodName.indexOf("(") > 0) {
            methodName = methodName.substring(0, methodName.indexOf("("));
        }

        String paramLength = request.getParameter("paramLength");
        String param = "";
        if (!StringUtil.isBlank(paramLength)) {
            param += "[";
            for (int i = 0; i < Integer.parseInt(paramLength); i++) {
                String paramIndexValue = request.getParameter("param" + i);
                if (i != 0) {
                    param += ",";
                }
                param += paramIndexValue;
            }
            param += "]";
        }
        MiDynamicCallClient miDynamicCallClient =
                new MiDynamicCallClient(serviceName.trim(), group.trim(), version.trim(), methodName.trim(),
                        param);
        try {
            return JSON.toJSON(miDynamicCallClient.fetchResult()).toString();
        } catch (Throwable e) {
            if (e instanceof MiException) {
                return ResultMessageBuilder.build(false, ((MiException) e).getErrorCode(),
                        ((MiException) e).getErrorMsg()).toJSONString();
            } else {
                return ResultMessageBuilder.build(false, ImanagerErrorEnum.E10009.getError(),
                        ImanagerErrorEnum.E10009.getCnMsg()).toJSONString();
            }
        }
    }

    /**
     * 接口方法列表
     *
     * @param request
     * @return
     */
    @PostMapping("listInterface")
    public String listInterface(HttpServletRequest request) {

        String serviceName = request.getParameter("serviceName");
        String group = request.getParameter("group");
        String version = request.getParameter("version");
        MiDynamicCallClient miDynamicCallClient = new MiDynamicCallClient(serviceName.trim(), group.trim(),
                version.trim(), null, null);
        MiResult miResult = null;
        try {
            miResult = miDynamicCallClient.fetchServiceMethods();
        } catch (Throwable throwable) {
            throwable.printStackTrace();
            return ResultMessageBuilder.build(false, ImanagerErrorEnum.E10009.getError(),
                    ImanagerErrorEnum.E10009.getCnMsg()).toJSONString();
        }

        System.out.println("服务方法详情" + JSON.toJSON(miResult).toString());
        return JSON.toJSON(miResult).toString();
    }
}
