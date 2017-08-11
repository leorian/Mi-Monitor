package org.ahstu.mi.monitor.enums;

import com.alibaba.fastjson.JSON;

/**
 * Created by xiezg@317hu.com on 2017/4/25 0025.
 */
public enum ImanagerErrorEnum {

    E10001("E10001", "Login Failure Public Private Key Expire", "用户密码公钥私钥加密策略过期，请重新进入登录页面！"),
    E10002("E10002", "Group Empty!", "分组为空！"),
    E10003("E10003", "ServiceName Empty!", "列表为空！"),
    E10004("E10004", "Version Empty!", "版本为空！"),
    E10005("E10005", "ServiceName Cannot Be Empty!", "接口名称不能为空！"),
    E10006("E10006", "Group Cannot Be Empty!", "组不能为空！"),
    E10007("E10007", "Version Cannot Be Empty!", "版本不能为空！"),
    E10008("E10008", "MethodName Cannot Be Empty!", "方法名称不能为空！"),
    E10009("E10009", "Remote Method Invocation Error！", "远程方法调用异常！");

    private String error;

    private String msg;

    private String cnMsg;

    ImanagerErrorEnum(String error, String msg, String cnMsg) {
        this.error = error;
        this.msg = msg;
        this.cnMsg = cnMsg;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public String getCnMsg() {
        return cnMsg;
    }

    public void setCnMsg(String cnMsg) {
        this.cnMsg = cnMsg;
    }

    @Override
    public String toString() {
        return JSON.toJSONString(this);
    }
}