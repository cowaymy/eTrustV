<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!-- char js -->
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/Chart.min.js"></script>
<!-- <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.min.js"></script>-->

<script type="text/javaScript" language="javascript">

    var lineChart;

    $(document).ready(function () {
        fn_getChartData();
    });

    function fn_getChartData() {
        Common.ajax("GET", "/sample/getLineChartData.do", $('#searchForm').serialize(), function (result) {
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

            /*
              '#1f77b4',
            '#ff7f0e',
            '#2ca02c',
            '#d62728',
            '#9467bd',
            '#8c564b',
            '#e377c2',
            '#7f7f7f',
             */
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

            console.log(columns[i] + " : " + dataArray[0] + ", " + dataArray[1] + ", " + dataArray[2] + ", " + dataArray[3] + ", " + dataArray[4]);

            var lineChartData = {
                label: columns[i],
                backgroundColor: color,
                fill: false,
                data: dataArray
            };

            dataSets.push(lineChartData);
        }

        var ctx = $("#lineChart");
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
                            labelString: 'Total'
                        }
                    }]
                }
            }
        };

        if (lineChart) {
            //console.log("lineChart destroy......");
            //lineChart.destroy();
            lineChart.data.datasets = dataSets;
            lineChart.update();
            console.log("lineChart update......");
        } else {
            lineChart = new Chart(ctx, chartOption);
            console.log("lineChart create......");
        }

    }

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

    <header class="pop_header"><!-- pop_header start -->
        <h1>Sales Key In Chart</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
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
                        <select class="w100p" id="pYear" name="pYear" onchange="fn_getChartData();">
                            <option value="2017" selected>2017</option>
                            <option value="2016" >2016</option>
                            <option value="2015">2015</option>
                        </select>
                    </td>
                </tr>
                </tbody>
            </table><!-- table end -->

        </form>

        <article class="grid_wrap_big" style="height:380px"><!-- grid_wrap start -->
            <div class="chart-container">
                <canvas id="lineChart"></canvas>
            </div>
        </article><!-- grid_wrap end -->
        <p class="mt20">/Public/SaleKeyInGraphChart.aspx</p>
    </section><!-- pop_body end -->

</div>
<!-- popup_wrap end -->