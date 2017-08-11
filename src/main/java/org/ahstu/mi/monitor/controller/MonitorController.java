package org.ahstu.mi.monitor.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Date;
import java.util.Map;

/**
 * Created by xiezg@317hu.com on 2017/8/11 0011.
 */
@Controller
@RequestMapping("monitor" +
        "")
public class MonitorController {

    @GetMapping("provider")
    public String provider(Map<String, Object> model) {
        return "provider";
    }

    @GetMapping("consumer")
    public String consumer(Map<String, Object> model) {
        return "consumer";
    }

    @GetMapping("rmi")
    public String rmi(Map<String, Object> model) {
        return "rmi";
    }

}
