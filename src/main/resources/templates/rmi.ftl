<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>

    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
    <title>Mi-RPC-Monitor</title>
    <link rel="Shortcut Icon" href="${ctxPath}/webFrame/bootstrap-3.3.5/bootstrap/images/logo.ico">
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link rel="stylesheet" href="${ctxPath}/webFrame/bootstrap-3.3.5/bootstrap/css/bootstrap.min.css">

    <!-- 可选的Bootstrap主题文件（一般不用引入） -->
    <link rel="stylesheet" href="${ctxPath}/webFrame/bootstrap-3.3.5/bootstrap/css/bootstrap-theme.min.css">

    #*分页插件jqgrid*#
    <link rel="stylesheet" href="${ctxPath}/webFrame/jqgrid-5.2.0/jqgrid/css/ui.jqgrid-bootstrap.css"/>

    <link rel="stylesheet" href="${ctxPath}/webFrame/jquery.jsonview.min.css"/>
    <style type="text/css">


        @media (min-width: 992px) {
            #nav-bar-left-list {
                width: 224px;
            }
        }

        @media (min-width: 1200px) {
            #nav-bar-left-list {
                width: 256px;
            }
        }


    </style>
    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="${ctxPath}/webFrame/bootstrap-3.3.5/jquery-1.11.3.min.js"></script>

    #*分页插件jqgrid*#
    <script src="${ctxPath}/webFrame/jqgrid-5.2.0/jqgrid/js/i18n/grid.locale-cn.js"></script>
    <script src="${ctxPath}/webFrame/jqgrid-5.2.0/jqgrid/js/jquery.jqGrid.min.js"></script>

    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="${ctxPath}/webFrame/bootstrap-3.3.5/bootstrap/js/bootstrap.min.js"></script>

    <script src="${ctxPath}/webFrame/underscore-min.js"></script>

    <script src="${ctxPath}/webFrame/echarts.min.js"></script>

    <script src="${ctxPath}/webFrame/jquery.jsonview.min.js"></script>

    <script type="text/javascript">
        var ctxPath = '$!{ctxPath}';
        $(function () {
            $.jgrid.defaults.width = $("#mainWindowPanel").width();
        });
    </script>
    <script>
        $(function () {
        });
    </script>
</head>
<body>
<!-- 头部 -->
<header id="header" class="navbar navbar-default navbar-fixed-top">
    <div class="container">
        <div class="navbar-collapse collapse header-navbar-collapse">
            <ul class="nav navbar-nav">
                <li><a href="javascript:void(0);"> Mi-RPC监控平台</a></li>
            </ul>
        </div>
    </div>
</header>
<br/>
<br/>
<br/>
<br/>
<br/>
<!-- body -->
<div class="container">
    <div class="row" id="ad_common_top" style="display:none;">
        <div class="col-md-12">
            <div class="bs-callout bs-callout-danger script"></div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="row" id="ad_page_top" style="display:none;">
                <div class="col-md-12">
                    <div class="bs-callout bs-callout-danger script"></div>
                </div>
            </div>

            <div class="row" id="mainWindowPanel">
                <div class="col-md-12">
                    <ul id="myTab" class="nav nav-tabs">
                        <li>
                            <a href="${ctxPath}/monitor/provider" data-toggle="tab">
                                服务者列表
                            </a>
                        </li>
                        <li>
                            <a href="${ctxPath}/monitor/consumer" data-toggle="tab">
                                消费者列表
                            </a>
                        </li>
                        <li class="active">
                            <a href="${ctxPath}/monitor/rmi" data-toggle="tab">
                                服务远程调用
                            </a>
                        </li>
                    </ul>
                    <div style="margin-top: 25px;">
                        <form class="form-horizontal" role="form" id="rmiForm">
                            <div class="form-group">
                                <label for="group" class="col-sm-2 control-label">组</label>
                                <div class="col-sm-10">
                                    <select class="form-control" id="group" name="group">
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="serviceName" class="col-sm-2 control-label">服务名称</label>
                                <div class="col-sm-10">
                                    <select class="form-control" id="serviceName" name="serviceName">
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="version" class="col-sm-2 control-label">版本</label>
                                <div class="col-sm-10">
                                    <select class="form-control" id="version" name="version">
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="methodName" class="col-sm-2 control-label">调用方法</label>
                                <div class="col-sm-10">
                                    <select class="form-control" id="methodName" name="methodName">

                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-2 control-label">方法参数</label>
                                <div class="col-sm-10" id="methodParamterPanel">
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-sm-offset-2 col-sm-10">
                                    <button type="button" id="rmiBtn" class="btn btn-info">远程调用</button>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="panel panel-primary">
                        <div class="panel-heading">
                            <h3 class="panel-title">服务远程调用结果展示区</h3>
                        </div>
                        <div class="panel-body" id="rmiResult">
                        </div>
                    </div>
                </div>
                <script type="text/javascript">
                    $(function () {
                        var serviceMethodArray;
                        //tab页切换事件
                        $("#myTab").delegate("a", "click", function () {
                            window.location = $(this).attr("href");
                        });

                        //服务方法参数列表
                        function serviceMethodParameterList() {
                            $("#methodParamterPanel").empty();
                            var methodName = $("#methodName").val();
                            var insistServiceMethodParameterDOList;
                            for (var i = 0; i < serviceMethodArray.length; i++) {
                                if (serviceMethodArray[i].simpleMethodName == methodName) {
                                    insistServiceMethodParameterDOList = serviceMethodArray[i].miServiceMethodParameterDOList;
                                    break;
                                }
                            }

                            if (insistServiceMethodParameterDOList.length > 0) {
                                var parameterModule = $("<div></div>");
                                for (var i = 0; i < insistServiceMethodParameterDOList.length; i++) {
                                    parameterModule.append("<div class='row'><div class='col-sm-12'><span style='color:blue'>第"
                                            + (insistServiceMethodParameterDOList[i].parameterIndex + 1) + "个参数：</span></div></div>");

                                    parameterModule.append("<div class='row'><div class='col-sm-2 text-center'>参数类型：</div><div class='col-sm-10'>"
                                            + insistServiceMethodParameterDOList[i].parameterTypeName.replace(/</g, '&lt;').replace(/>/g, "&gt;") + "</div></div>"
                                    );
                                    if (insistServiceMethodParameterDOList[i].jsonObject == 'false' || insistServiceMethodParameterDOList[i].jsonObject == false) {
                                        parameterModule.append("<div class='row'><div class='col-sm-2 text-center'>参数示例：</div><div class='col-sm-10'>" +
                                                insistServiceMethodParameterDOList[i].parameterExample.replace(/</g, '&lt;').replace(/>/g, "&gt;")
                                                + "</div></div>");
                                    } else {
                                        parameterModule.append($("<div class='row'></div>").append("<div class='col-sm-2 text-center'>参数示例：</div>").append($("<div class='col-sm-10'></div>").JSONView(insistServiceMethodParameterDOList[i].parameterExample
                                                .replace(/</g, '&lt;').replace(/>/g, "&gt;").replace(/\\"/g, ""))));
                                    }


                                    if (insistServiceMethodParameterDOList[i].parameterHtmlDomType == "INPUT") {
                                        parameterModule.append("<div class='row'><div class='col-sm-12'>" +
                                                "<input type='text' id='param" + insistServiceMethodParameterDOList[i].parameterIndex + "' " +
                                                "name='param" + insistServiceMethodParameterDOList[i].parameterIndex + "' " +
                                                "class='form-control'placeholder='请输入" + (insistServiceMethodParameterDOList[i].parameterIndex + 1) + "个参数'/>" + "</div></div>"
                                        )
                                        ;
                                    } else if (insistServiceMethodParameterDOList[i].parameterHtmlDomType == "TEXTAREA") {
                                        parameterModule.append("<div class='row'><div class='col-sm-12'>" + "<textarea id='param"
                                                + insistServiceMethodParameterDOList[i].parameterIndex + "'" +
                                                " name='param" + insistServiceMethodParameterDOList[i].parameterIndex + "' " +
                                                "class='form-control' placeholder='请输入" + (insistServiceMethodParameterDOList[i].parameterIndex + 1) + "个参数' rows='5'></textarea>" + "</div></div>");
                                    } else {
                                        parameterModule.append("<div class='row'><div class='col-sm-12'>" +
                                                insistServiceMethodParameterDOList[i].parameterHtmlDomType +
                                                "</div></div>");
                                    }

                                    parameterModule.append("<br/>");
                                }

                                $("#methodParamterPanel").append(parameterModule);
                                $("#methodParamterPanel").append("<input type='hidden' name='paramLength' id='paramLength' value='" + insistServiceMethodParameterDOList.length + "' />");
                            }

                        }

                        //服务方法列表
                        function serviceMethodList() {
                            $.post("${ctxPath}/js2Mi/listInterface", {
                                "group": $("#group").val(),
                                "serviceName": $("#serviceName").val(),
                                "version": $("#version").val()
                            }, function (data) {
                                if (data.success) {
                                    var options = "";
                                    serviceMethodArray = data.module;
                                    if (serviceMethodArray.length > 0) {
                                        for (var i = 0; i < serviceMethodArray.length; i++) {
                                            options += ("<option value='" + serviceMethodArray[i].simpleMethodName + "'>"
                                            + serviceMethodArray[i].absoluteMethodName.replace(/</g, '&lt;').replace(/>/g, "&gt;")
                                            + "</option>")
                                        }
                                    }
                                    $("#methodName").html("");
                                    $("#methodName").html(options);
                                    serviceMethodParameterList();

                                }
                            }, "json");
                        }

                        //版本列表
                        function versionList() {
                            $.post("${ctxPath}/mi/versionList", {
                                "group": $("#group").val(),
                                "serviceName": $("#serviceName").val()
                            }, function (data) {
                                if (data.success) {
                                    var options = "";
                                    var serviceNameArray = data.data;
                                    if (serviceNameArray.length > 0) {
                                        for (var i = 0; i < serviceNameArray.length; i++) {
                                            options += ("<option>" + serviceNameArray[i] + "</option>")
                                        }
                                    }
                                    $("#version").html("");
                                    $("#version").html(options);
                                    serviceMethodList();
                                }
                            }, "json");
                        }

                        //服务名称列表
                        function serviceNameList() {
                            $.post("${ctxPath}/mi/serviceNameList", {"group": $("#group").val()}, function (data) {
                                if (data.success) {
                                    var options = "";
                                    var serviceNameArray = data.data;
                                    if (serviceNameArray.length > 0) {
                                        for (var i = 0; i < serviceNameArray.length; i++) {
                                            options += ("<option>" + serviceNameArray[i] + "</option>")
                                        }
                                    }
                                    $("#serviceName").html("");
                                    $("#serviceName").html(options);
                                    versionList();

                                }
                            }, "json");
                        }

                        //分组列表
                        $.post("${ctxPath}/mi/groupList", null, function (data) {
                            if (data.success) {
                                var options = "";
                                var groupArray = data.data;
                                if (groupArray.length > 0) {
                                    for (var i = 0; i < groupArray.length; i++) {
                                        options += ("<option>" + groupArray[i] + "</option>")
                                    }
                                }
                                $("#group").html("");
                                $("#group").html(options);
                                serviceNameList();
                            }
                        }, "json");

                        //分组改变事件
                        $("#group").change(function () {
                            serviceNameList();
                        });

                        //服务名称改变事件
                        $("#serviceName").change(function () {
                            versionList();
                        });

                        //版本改变事件
                        $("#version").change(function () {
                            serviceMethodList();
                        });

                        //方法列表改变事件
                        $("#methodName").change(function () {
                            serviceMethodParameterList();
                        });

                        //远程调用
                        $("#rmiBtn").click(function () {
                            $.post("${ctxPath}/js2Mi/dynamicCall", $("#rmiForm").serialize(), function (data) {
                                $("#rmiResult").empty();
                                $("#rmiResult").JSONView(data);
                            }, "json");
                        });

                    });
                </script>
            </div>

            <div class="row" id="ad_page_bottom" style="display:none;">
                <div class="col-md-12">
                    <div class="bs-callout bs-callout-danger script"></div>
                </div>
            </div>

        </div>
    </div>

    <div class="row" id="ad_common_bottom" style="display:none;">
        <div class="col-md-12">
            <div class="bs-callout bs-callout-danger script"></div>
        </div>
    </div>

</div>
<br/>
<br/>
<br/>
<!-- 尾部 -->
<footer class="footer navbar navbar-default navbar-fixed-bottom">
    <div class="container">
        <div class="navbar-collapse collapse header-navbar-collapse">
            <ul class="nav navbar-nav">
                <li><a href="javascript:void(0);"><img src="${ctxPath}/webFrame/timg.jpg" width="50px" height="30px"/>&nbsp;&nbsp;洛天个人工作室</a>
                </li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li>
                    <a class="button button-little bg-red" href="javascript:void(0);">
                        <span class="icon-power-off"></span>
                        开源组织
                    </a>
                </li>
            </ul>
        </div>
    </div>
</footer>

</body>
</html>