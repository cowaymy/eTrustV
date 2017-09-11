<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!-- char js -->
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/Chart.min.js"></script>
<!-- <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.min.js"></script>-->

<script type="text/javaScript" language="javascript">

    var netSalesChart;

    $(document).ready(function () {
        fn_getNetSalesChart();
    });

    function fn_getNetSalesChart() {
        Common.ajax("GET", "/chart/getNetSalesChart.do", $('#searchForm').serialize(), function (result) {
            console.log("성공.");
            console.log("data : " + result);

            fn_drawChart(result);
        });
    }

    function fn_drawChart(data) {

        var Outright = "Total Outright";
        var Rental = "Total Rental";
        var Installment = "Total Installment";

        var columns = [Outright, Rental, Installment];
        var labels = [];
        var dataSets = [];
        var totOutrgt = [];
        var totRental = [];
        var totInstall = [];

        for (var i = 0; i < data.length; i++) {
            labels.push(data[i].pvMonth);
        }

        for (var i = 0; i < data.length; i++) {
            totOutrgt.push(data[i].totOutrgt);
            totRental.push(data[i].totRental);
            totInstall.push(data[i].totInstall);
        }

        for (var i = 0; i < columns.length; i++) {

            var dataArray = [];
            var color;

            switch (columns[i]) {
                case Outright:
                    dataArray = totOutrgt;
                    color = '#ff6384';
                    break;
                case Rental:
                    dataArray = totRental;
                    color = '#36a2eb';
                    break;
                case Installment:
                    dataArray = totInstall;
                    color = '#cc65fe';
                    break;
                default:
                    dataArray = [];
                    break;
            }

            var netSalesChartData = {
                label: columns[i],
                backgroundColor: color,
                fill: false,
                data: dataArray
            };

            dataSets.push(netSalesChartData);
        }

        var ctx = $("#netSalesChart");
        var chartOption = {
            type: 'line',
            data: {
                labels: labels,
                datasets: dataSets
            },
            options: {
                responsive: true,
                hoverMode: 'index',
                stacked: false,
                title: {
                    display: true,
                    text: 'Key In Net Sales By Application Type'
                },
                scales: {
                    xAxes: [{
                        display: true,
                        scaleLabel: {
                            display: true,
                            fontSize: 15,
                            labelString: 'Month'
                        }
                    }],
                    yAxes: [{
                        display: true,
                        scaleLabel: {
                            display: true,
                            fontSize: 15,
                            labelString: 'Net Quantity'
                        }
                    }]
                }
            }
        };


        if (netSalesChart) {
            netSalesChart.destroy();
            console.log("netSalesChart destroy......");
        }

        netSalesChart = new Chart(ctx, chartOption);

        // Define a plugin to provide data labels
        Chart.plugins.register({
            afterDatasetsDraw: function(chart, easing) {
                // To only draw at the end of animation, check for easing === 1
                var ctx = chart.ctx;

                chart.data.datasets.forEach(function (dataset, i) {
                    var meta = chart.getDatasetMeta(i);
                    if (!meta.hidden) {
                        meta.data.forEach(function(element, index) {
                            // Draw the text in black, with the specified font
                            ctx.fillStyle = "#7f7f7f";

                            var fontSize = 12;
                            var fontStyle = Chart.defaults.global.defaultFontStyle;
                            var fontFamily = Chart.defaults.global.defaultFontFamily;
                            ctx.font = Chart.helpers.fontString(fontSize, fontStyle, fontFamily);

                            // Just naively convert to string for now
                            var dataString = dataset.data[index].toString();

                            // Make sure alignment settings are correct
                            ctx.textAlign = 'center';
                            ctx.textBaseline = 'middle';

                            var padding = 5;
                            var position = element.tooltipPosition();
                            ctx.fillText(dataString, position.x, position.y - (fontSize / 2) - padding);
                        });
                    }
                });
            }
        });

    }

    function fn_closeNetSalesCharPop(){
        if (netSalesChart) {
            netSalesChart.destroy();
            console.log("fn_closeNetSalesCharPop : netSalesChart destroy......");
        }
        $("#netSalesChartDivPop").remove();
    }

</script>
<div id="popup_wrap" class="popup_wrap size_big"><!-- popup_wrap start -->

    <header class="pop_header"><!-- pop_header start -->
        <h1>Key In Net Sales By Application Type</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="javascript:void(0);" onclick="javascript:fn_closeNetSalesCharPop();">CLOSE</a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->
        <form id="searchForm">
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:*"/>
                    <col style="width:25%"/>
                </colgroup>
                <tbody>
                <tr>
                    <td>
                        <select class="w100p">
                            <optgroup label="group1">
                                <option value="">11</option>
                                <option value="">22</option>
                                <option value="">33</option>
                            </optgroup>
                            <optgroup label="group2" class="optgroup_text">
                                <option value="">11</option>
                                <option value="">22</option>
                                <option value="">33</option>
                            </optgroup>
                        </select>
                    </td>
                    <td>
                        <select class="w100p" id="pYear" name="pYear" onchange="fn_getNetSalesChart();">
                            <option value="2017" selected>2017</option>
                            <option value="2016" >2016</option>
                            <option value="2015">2015</option>
                            <option value="2014">2014</option>
                            <option value="2013">2013</option>
                            <option value="2012">2012</option>
                            <option value="2011">2011</option>
                            <option value="2010">2010</option>
                            <option value="2009">2009</option>
                            <option value="2008">2008</option>
                            <option value="2007">2007</option>
                            <option value="2006">2006</option>
                        </select>
                    </td>
                </tr>
                </tbody>
            </table><!-- table end -->

        </form>

        <article class="grid_wrap"><!-- grid_wrap start -->
            <div class="chart-container">
                <canvas id="netSalesChart"></canvas>
            </div>
        </article><!-- grid_wrap end -->
        <p class="mt20">/chart/netSalesChartPop.jsp</p>
    </section><!-- pop_body end -->

</div>
<!-- popup_wrap end -->