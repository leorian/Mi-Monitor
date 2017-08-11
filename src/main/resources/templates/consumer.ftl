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
                        <li class="active">
                            <a href="${ctxPath}/monitor/consumer" data-toggle="tab">
                                消费者列表
                            </a>
                        </li>
                        <li>
                            <a href="${ctxPath}/monitor/rmi" data-toggle="tab">
                                服务远程调用
                            </a>
                        </li>
                    </ul>
                    <div style="margin-top: 25px; padding-left: 15px;">
                        <form class="form-inline" role="form" id="consumerForm">
                            <div class="form-group">
                                <label class="control-label" for="serviceName">服务名：</label>
                                <input type="text" class="form-control" id="serviceName" name="serviceName">
                            </div>
                            <div class="form-group">
                                <label class="control-label" for="group">组：</label>
                                <input type="text" class="form-control" id="group" name="group">
                            </div>
                            <div class="form-group">
                                <label class="control-label" for="ip">IP：</label>
                                <input type="text" class="form-control" id="ip" name="ip">
                            </div>
                            <button type="button" id="searchBtn" class="btn btn-info">搜索</button>
                            <button type="button" id="resetBtn" class="btn btn-default">清空</button>
                        </form>
                    </div>

                    <div style="margin-top: 20px;">
                        <table id="consumerTable" class="table table-bordered">
                            <thead>
                            <tr>
                                <th>序号</th>
                                <th>服务名</th>
                                <th>版本</th>
                                <th>组</th>
                                <th>ip</th>
                                <th>操作</th>
                            </tr>
                            </thead>
                            <tbody>

                            </tbody>
                        </table>
                    </div>
                </div>
                <!-- 模态框（Modal） -->
                <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">
                                    &times;
                                </button>
                                <h4 class="modal-title" id="myModalLabel">
                                    消费信息
                                </h4>
                            </div>
                            <div class="modal-body" id="myModalBody" style="word-break:break-all; word-wrap:break-all;">
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">关闭
                                </button>
                            </div>
                        </div><!-- /.modal-content -->
                    </div><!-- /.modal -->
                </div>
                <script type="text/template" id="consumerTableTemplate">
                    <% _.each(data, function(n,index) { %>
                    <tr>
                        <td><%= index+1 %></td>
                        <td><%= n.interfaceName %></td>
                        <td><%= n.version %></td>
                        <td><%= n.group %></td>
                        <td><%= n.ip %></td>
                        <td>
                            <button data-obj='<%= JSON.stringify(n) %>' type="button" class="btn btn-xs btn-link btn-detail launch">详情
                            </button>
                        </td>
                    </tr>
                    <% });%>
                </script>
                <script type="text/template" id="consumerDetailTemplate">
                    <div>
                        <form class="form-horizontal">
                            <div class="form-group">
                                <label class="col-sm-3 control-label">ID：</label>
                                <div class="col-sm-9">
                                    <p class="form-control-static"><%= id %></p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">服务名：</label>
                                <div class="col-sm-9">
                                    <p class="form-control-static"><%= interfaceName %></p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">组名：</label>
                                <div class="col-sm-9">
                                    <p class="form-control-static"><%= group %></p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">IP：</label>
                                <div class="col-sm-9">
                                    <p class="form-control-static"><%= ip %></p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">端口号：</label>
                                <div class="col-sm-9">
                                    <p class="form-control-static"><%= port %></p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">version：</label>
                                <div class="col-sm-9">
                                    <p class="form-control-static"><%= version %></p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">请求超时时间：</label>
                                <div class="col-sm-9">
                                    <p class="form-control-static"><%= clientTimeout %></p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label">连接数：</label>
                                <div class="col-sm-9">
                                    <p class="form-control-static"><%= connectionNum %></p>
                                </div>
                            </div>
                        </form>
                    </div>
                </script>
                <script type="text/javascript">
                    $(function () {

                        //服务列表查询事件
                        function consumerList() {
                            $.post("${ctxPath}/mi/consumerList", {
                                "serviceName": $("#serviceName").val(),
                                "group": $("#group").val(),
                                "ip": $("#ip").val()
                            }, function (data) {
                                if (data.success && data.data.length > 0) {
                                    $('#consumerTable').find("tbody").html(_.template($('#consumerTableTemplate').html(), {variable: 'data'})(data.data));
                                } else {
                                    $("#consumerTable").find("tbody").html(" <tr><td colspan=\"6\" style=\"text-align: center;\">暂无信息！</td> </tr>");
                                }
                            }, "json");
                        }

                        consumerList();

                        $("#searchBtn").click(function () {
                            consumerList();
                        });

                        $("#resetBtn").click(function () {
                            $("#serviceName").val("");
                            $("#group").val("");
                            $("#ip").val();
                            consumerList();
                        });

                        //tab页切换事件
                        $("#myTab").delegate("a", "click", function () {
                            window.location = $(this).attr("href");
                        });

                        $("#consumerTable").delegate(".btn-detail", "click", function () {
                            var serviceMetaStr = $(this).attr("data-obj");
                            $('#myModalBody').html(_.template($('#consumerDetailTemplate').html())($.parseJSON(serviceMetaStr)));
                            $("#myModal").modal("show");
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