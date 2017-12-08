<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

    .aui-grid-user-custom-left { text-align:left; }

    .aui-grid-user-custom-right { text-align:right;}

    .mycustom-disable-color { color : #cccccc; }

    .aui-grid-body-panel table tr:hover { background:#D9E5FF; color:#000; }

    .aui-grid-main-panel .aui-grid-body-panel table tr td:hover {background:#D9E5FF; color:#000;}

</style>

<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>

<script type="text/javaScript" language="javascript">

    var myGridID;

    var columnLayout = [
                                    {dataField:"serialNo" ,headerText:"Serial Number",width:250 ,height:30},
                                    {dataField:"whLocCode" ,headerText:"Location Code",width:120 ,height:30},
                                    {dataField:"whLocDesc" ,headerText:"Location Description",width:350 ,height:30},
                                    {dataField:"whLocType" ,headerText:"Location Type",width:120 ,height:30},
                                    {dataField:"matnr" ,headerText:"Material Code",width:120 ,height:30},
                                    {dataField:"stkDesc" ,headerText:"Material Name",width:200 ,height:30},
                                    {dataField:"stkType" ,headerText:"Material Type",width:150 ,height:30},
                                    {dataField:"stkCtgry" ,headerText:"Material Category",width:150 ,height:30},
                                    {dataField:"gltri" ,headerText:"Prod Date",width:150 ,height:30},
                                    {dataField:"lwedt" ,headerText:"GR Date",width:150 ,height:30},
                                    {dataField:"swaok" ,headerText:"Final Issue",width:150 ,height:30},
                                    {dataField:"crtDt" ,headerText:"Create Date",width:120 ,height:30}
                                    ];

    var gridPros = {
                                editable : false,
                                displayTreeOpen : true,
                                showRowCheckColumn : false,
                                showStateColumn : false,
                                showBranchOnGrouping : false
                            };


    $(document).ready(function() {

        myGridID = AUIGrid.create("#main_grid_wrap", columnLayout, gridPros);

        AUIGrid.bind(myGridID, "cellClick", function( event ) {});
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) { });
        AUIGrid.bind(myGridID, "ready", function(event) { });

    });

    $(function() {

        doGetCombo('/common/selectCodeList.do', '11', '','srchcatagorytype', 'M' , 'f_multiCombo');
        doGetCombo('/common/selectCodeList.do', '15', '','materialtype', 'M' , 'f_multiCombo');

        $("#search").click(function(){

                searchAjax();
        });

        $("#srchmaterial").keypress(function(event) {

            if (event.which == '13')
            {
                $("#svalue").val($("#srchmaterial").val());
                $("#sUrl").val("/logistics/material/materialcdsearch.do");
                $("#searchtype").val("search");

                Common.searchpopupWin("searchForm", "/common/searchPopList.do","stock");
            }
        });

        $("#location").keypress(function(event) {

            $('#hiddenLoc').val('');

            if (event.which == '13')
            {
                $("#ltype").val('hiddenLoc');
                $("#svalue").val($('#location').val());
                $("#sUrl").val("/logistics/organization/locationCdSearch.do");

                Common.searchpopupWin("searchForm", "/common/searchPopList.do","location");
            }
        });

    });

    function searchAjax() {

        if($('#location').val() == "")
        {
            $('#hiddenLoc').val() == "";
        }

        var url = "/logistics/SerialLocation/searchSerialLocationList.do";
        var param = $('#searchForm').serializeJSON();

        Common.ajax("POST" , url , param , function(data) {

            AUIGrid.setGridData(myGridID, data.dataList);
        });
    }



    function fn_itempopList(data) {

        var rtnVal = data[0].item;

        if ($("#searchtype").val() == "search")
        {
            $("#srchmaterial").val(rtnVal.itemcode);
        }
        else if($("#ltype").val() == "hiddenLoc")
        {
            $("#hiddenLoc").val(rtnVal.locid);
            $("#location").val(rtnVal.locdesc);
        }
        else
        {
            var rowPos = "first";
            var rowList = {
                    serialNoPop : '',
                    matnrPop : rtnVal.itemcode
            };

            AUIGrid.addRow(popGridId, rowList, rowPos);
        }

        $("#searchtype").val('');
        $("#svalue").val();
    }

    function f_multiCombo() {
        $(function() {
            $('#srchcatagorytype').change(function() {
                }).multipleSelect({
                selectAll : true,
                width : '80%'
            });

            $('#materialtype').change(function() {
            }).multipleSelect({
                selectAll : true, // 전체선택
                width : '80%'
            });
        });
    }

</script>

<section id="content"><!-- content start -->

    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Logistics</li>
        <li>Report</li>
        <li>Serial Location</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Serial Location</h2>
         <ul class="right_btns">
             <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
        </ul>
    </aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->

        <form id="searchForm" name="searchForm">

            <input type="hidden" id="lvalue" name="lvalue"/>
            <input type="hidden" id="lUrl"   name="lUrl"  />
            <input type="hidden" id="ltype"  name="ltype" />
            <input type="hidden" id="searchtype" name="searchtype"/>

            <table class="type1"><!-- table start -->

                <caption>table</caption>

                <colgroup>
                    <col style="width:140px" />
                    <col style="width:*" />
                    <col style="width:140px" />
                    <col style="width:*" />
                    <col style="width:140px" />
                    <col style="width:*" />
                </colgroup>

                <tbody>
                    <tr>
                        <th scope="row">Material Code</th>
                        <td colspan="2">
                            <input type="text" id="srchmaterial" name="srchmaterial"  class="w100p" />
                        </td>
                        <th scope="row">Category Type</th>
                        <td colspan="2">
                            <select id="srchcatagorytype" name="srchcatagorytype[]" class="w100p" /></select>
                        </td>
                    </tr>

                    <tr>
                        <th scope="row">Serial Number</th>
                        <td colspan="2">
                            <input type="text" id="srchserial" name="srchserial"  class="w100p" />
                        </td>

                        <th scope="row">Material Type</th>
                        <td colspan="2">
                            <select id="materialtype" name="materialtype[]"  class="w100p" /></select>
                        </td>
                    </tr>

                    <tr>
                        <th scope="row">Location</th>
                        <td colspan="2">
                            <input type="hidden"  id="hiddenLoc" name="hiddenLoc">
                            <input type="text" class="w100p" id="location"  name="location" placeholder="Press 'Enter' to Search">
                        </td>
                        <th scope="row">Create Date</th>
                        <td colspan="2">
                            <div class="date_set"><!-- date_set start -->
                                <p>
                                  <input id="srchcrtdtfrom" name="srchcrtdtfrom" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date">
                                </p>
                                    <span>To</span>
                                <p>
                                   <input id="srchcrtdtto" name="srchcrtdtto" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date">
                                </p>
                            </div><!-- date_set end -->
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
    </section><!-- search_table end -->

    <section class="search_result"><!-- search_result start -->

        <div id="main_grid_wrap" class="mt10" style="height:450px"></div>

    </section><!-- search_result end -->

</section><!-- content end -->