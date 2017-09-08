<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!-- char js -->
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/Chart.min.js"></script>
<!-- <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.min.js"></script>-->

<script type="text/javaScript" language="javascript">

    var barChart;

    $(document).ready(function () {
        fn_getChartData();
    });

    function fn_getChartData() {
        Common.ajax("GET", "/sample/getChartData.do", $('#searchForm').serialize(), function (result) {
            console.log("성공.");
            console.log("data : " + result);

            fn_drawChart(result);
        });
    }

    function fn_drawChart(data) {

        var Sales = "Sales(Key In)";
        var NetSales = "NetSales";
        var Membership = "Membership(Key In)";
        var NewMember = "New Member(Key In)";

        var columns = [Sales, NetSales, Membership, NewMember];
        var labels = [];
        var dataSets = [];
        var salesCnt = [];
        var newSalesCnt = [];
        var mbrshCnt = [];
        var memCnt = [];
        var back = ["#ff0000", "blue", "gray"];

        for (var i = 0; i < data.length; i++) {
            labels.push(data[i].anlysMonth);
        }

        for (var i = 0; i < data.length; i++) {
            salesCnt.push(data[i].salesCnt);
            newSalesCnt.push(data[i].newSalesCnt);
            mbrshCnt.push(data[i].mbrshCnt);
            memCnt.push(data[i].memCnt);
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
                case Sales:
                    dataArray = salesCnt;
                    color = '#ff6384';
                    break;
                case NetSales:
                    dataArray = newSalesCnt;
                    color = '#36a2eb';
                    break;
                case Membership:
                    dataArray = mbrshCnt;
                    color = '#cc65fe';
                    break;
                case NewMember:
                    dataArray = memCnt;
                    color = '#ffce56';
                    break;
                default:
                    dataArray = [];
                    break;
            }

            console.log(columns[i] + " : " + dataArray[0] + ", " + dataArray[1] + ", " + dataArray[2] + ", " + dataArray[3] + ", " + dataArray[4]);

            var barChartData = {
                label: columns[i],
                backgroundColor: color, //back[Math.floor(Math.random() * back.length)],
                data: dataArray
            };

            dataSets.push(barChartData);
        }

        var ctx = $("#barChart");
        var chartOption = {
            type: 'bar',
            data: {
                labels: labels,
                datasets: dataSets
            },
            options: {
                responsive: true,
                title: {
                    display: true,
                    text: "Key-In / Net Sales (EXCLUDE PST)"
                },
                legend :  {
                   position : "top" //"bottom"
                },
                tooltips: {
                    mode: 'index',
                    intersect: true
                },
                scales: {
                    xAxes: [{
                        display: true,
                        scaleLabel: {
                            display: true,
                            fontSize : 15,
                            labelString: 'Month'
                        }
                    }],
                    yAxes: [{
                        display: true,
                        scaleLabel: {
                            display: true,
                            fontSize : 15,
                            labelString: 'Total'
                        }
                    }]
                }
            }
        };

        if (barChart) {
            //console.log("barChart destroy......");
            //barChart.destroy();
            barChart.data.datasets = dataSets;
            barChart.update();
            console.log("barChart update......");
        } else {
            barChart = new Chart(ctx, chartOption);
            console.log("barChart create......");
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
                        <select class="w100p" id="pYear" onchange="fn_getChartData();">
                            <option value="2017" selected>2017</option>
                            <option value="2016">2016</option>
                            <option value="2015">2015</option>
                        </select>
                    </td>
                </tr>
                </tbody>
            </table><!-- table end -->

        </form>

        <article class="grid_wrap_big" style="height:380px"><!-- grid_wrap start -->
            <div class="chart-container">
                <canvas id="barChart"></canvas>
            </div>
        </article><!-- grid_wrap end -->
        <p class="mt20">/Public/SaleKeyInGraphChart.aspx</p>
    </section><!-- pop_body end -->

</div>
<!-- popup_wrap end -->