package org.ahstu.mi.monitor.util;


import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;

/**
 * Created by xiezg@317hu.com on 2017/8/11 0011.
 */
public class ResultMessageBuilder {
    public ResultMessageBuilder() {
    }

    public static ResultMessageBuilder.ResultMessage build() {
        return new ResultMessageBuilder.ResultMessage();
    }

    public static ResultMessageBuilder.ResultMessage build(Object data) {
        return new ResultMessageBuilder.ResultMessage(data);
    }

    public static ResultMessageBuilder.ResultMessage build(boolean success, String errCode, String errMsg) {
        return new ResultMessageBuilder.ResultMessage(success, errCode, errMsg);
    }

    public static ResultMessageBuilder.ResultMessage build(boolean success, String errCode, String errMsg, Object data) {
        return new ResultMessageBuilder.ResultMessage(success, errCode, errMsg, data);
    }

    public static ResultMessageBuilder.ResultMessageRaw buildRaw(String jsonStr) {
        return new ResultMessageBuilder.ResultMessageRaw(jsonStr);
    }

    public static class ResultMessageRaw {
        private String jsonStr = null;

        public ResultMessageRaw() {
        }

        public ResultMessageRaw(String jsonStr) {
            this.jsonStr = jsonStr;
        }

        public String getJsonStr() {
            return this.jsonStr;
        }

        public void setJsonStr(String jsonStr) {
            this.jsonStr = jsonStr;
        }

        public String toJSONString() {
            StringBuilder buff = new StringBuilder("{\"success\": true, \"data\": ");
            buff.append(this.jsonStr).append("}");
            return buff.toString();
        }
    }

    public static class ResultMessage {
        private boolean success = true;
        private String errMsg = null;
        private String errCode = null;
        private Object data = null;

        public ResultMessage() {
        }

        public ResultMessage(Object data) {
            this.data = data;
        }

        public ResultMessage(boolean success, String errCode, String errMsg) {
            this.success = success;
            this.errCode = errCode;
            this.errMsg = errMsg;
        }

        public ResultMessage(boolean success, String errCode, String errMsg, Object data) {
            this.success = success;
            this.errMsg = errMsg;
            this.errCode = errCode;
            this.data = data;
        }

        public boolean isSuccess() {
            return this.success;
        }

        public ResultMessageBuilder.ResultMessage setSuccess(boolean success) {
            this.success = success;
            return this;
        }

        public String getErrMsg() {
            return this.errMsg;
        }

        public ResultMessageBuilder.ResultMessage setErrMsg(String errMsg) {
            this.errMsg = errMsg;
            return this;
        }

        public Object getData() {
            return this.data;
        }

        public ResultMessageBuilder.ResultMessage setData(Object data) {
            this.data = data;
            return this;
        }

        public String getErrCode() {
            return this.errCode;
        }

        public void setErrCode(String errCode) {
            this.errCode = errCode;
        }

        public String toJSONString() {
            return JSON.toJSONString(this, new SerializerFeature[]{SerializerFeature.DisableCircularReferenceDetect});
        }

        public String toJSONString(String dateFormat) {
            return JSON.toJSONStringWithDateFormat(this, dateFormat, new SerializerFeature[]{SerializerFeature.DisableCircularReferenceDetect});
        }
    }
}
