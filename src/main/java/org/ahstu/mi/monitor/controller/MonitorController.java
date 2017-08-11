package org.ahstu.mi.monitor.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * Created by xiezg@317hu.com on 2017/8/11 0011.
 */
@Controller
@RequestMapping("monitor")
public class MonitorController {

    @GetMapping("provider")
    public String provider(Map<String, Object> model, HttpServletRequest request) {
        model.put("ctxPath", request.getContextPath());
        return "provider";
    }

    @GetMapping("consumer")
    public String consumer(Map<String, Object> model, HttpServletRequest request) {
        model.put("ctxPath", request.getContextPath());
        return "consumer";
    }

    @GetMapping("rmi")
    public String rmi(Map<String, Object> model, HttpServletRequest request) {
        model.put("ctxPath", request.getContextPath());
        return "rmi";
    }

}
