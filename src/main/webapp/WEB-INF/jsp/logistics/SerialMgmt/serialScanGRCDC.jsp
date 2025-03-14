<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

    .aui-grid-user-custom-left { text-align:left; }

    .aui-grid-user-custom-right { text-align:right;}

    .mycustom-disable-color { color : #cccccc; }

    .aui-grid-body-panel table tr:hover { background:#D9E5FF; color:#000; }

    .aui-grid-main-panel .aui-grid-body-panel table tr td:hover {background:#D9E5FF; color:#000;}

    #barScanWindow { font-size:13px; }
    #barScanWindow label, input { display:inline; }
    #barScanWindow input.text { margin-bottom:10px; width:95%; padding: 0.1em;  }
    #barScanWindow fieldset { padding:0; border:0; margin-top:10px; }

    .my-row-style { background:#FF5733; font-weight:bold; color:#22741C; }

</style>

<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>

<script type="text/javaScript" language="javascript">

    var myGridID;
    var myDetailGridID;
    var myBarScanGridID;
    var mySerialGridID;

    var ItmCodeMap;

    var SeqNo;
    var SeqGroup;

    var columnLayout = [
                                      {dataField:"delno", headerText:"Delivery No", width:220, height:30},
                                      {dataField:"reqstno", headerText:"Request No", width:220, height:30},
                                      {dataField:"reqstdt", headerText:"Request Date", width:220, height:30, visible:false},
                                      {dataField:"stktrans", headerText:"Stock Transaction", width:150, height:30},
                                      {dataField:"stkactivity", headerText:"Stock Activity", width:200, height:30},
                                      {dataField:"frmloc", headerText:"From Location", width:220, height:30},
                                      {dataField:"toloc", headerText:"To Location", width:220, height:30},
                                      {dataField:"frmlocid", headerText:"From Location ID", width:220, height:30, visible:false},
                                      {dataField:"tolocid", headerText:"To Location ID", width:220, height:30, visible:false},
                                      {dataField:"deldate", headerText:"Delivery Date", width:140, height:30},
                                      {dataField:"delqty", headerText:"Delivery Qty", width:110, height:30},
                                      {dataField:"crt", headerText:"Creator", width:110, height:30},
                                      {dataField:"crtdt", headerText:"Created Date", width:120, height:30}
                                    ];

    var detailLayout =   [
                                      {dataField:"itmcode", headerText:"Item Code", width:115, height:30},
                                      {dataField:"itmdesc", headerText:"Item Description", width:300, height:30},
                                      {dataField:"delqty", headerText:"Delivery Qty", width:100, height:30},
                                      {dataField:"scanqty", headerText:"Scanned Qty", width:100, height:30},
                                      {dataField:"remainqty", headerText:"Remaining Qty", width:150, height:30, visible:false}
                                    ];

    var barScanLayout = [
                                        {dataField:"seqno", headerText:"Seq No.", width:70, height:30},
                                        {dataField:"itmcode", headerText:"Item Code", width:110, height:30},
                                        {dataField:"boxno", headerText:"Box No.", width:230, height:30},
                                        {dataField:"unit", headerText:"Unit", width:60, height:30},
                                        {dataField:"status", headerText:"Status", width:40, height:30, visible:false},
                                        {dataField:"serialno", headerText:"Serial No", width:40, height:30, visible:false}
                                      ];

    var serialDetailLayout = [
                                             {dataField:"serialno", headerText:"Serial No.", width:180, height:30},
                                             {dataField:"seq", headerText:"Seq No.", width:75, height:30},
                                             {dataField:"boxno", headerText:"Box No.", width:180, height:30},
                                             {dataField:"crt", headerText:"Creator", width:110, height:30},
                                             {dataField:"crtdt", headerText:"Created Date", width:120, height:30}
                                           ];

    var gridPros = {
                               editable : false,
                               fixedColumnCount : 2,
                               showRowCheckColumn : false,
                               showStateColumn : false,
                               showBranchOnGrouping : false,
                               enableCellMerge : true,
                               groupingFields : ["delno"]
                            };

    var detailGridPros = {
                                        editable : false,
                                        showRowCheckColumn : false,
                                        showStateColumn : false,
                                        showBranchOnGrouping : false
                                     };


    var barScanGridPros = {
                                            editable : false,
                                            showRowCheckColumn : true,
                                            showRowAllCheckBox : false,
                                            showStateColumn : false,
                                            showBranchOnGrouping : false
                                         };

    var serialGridPros = {
                                        editable : false,
                                        showRowAllCheckBox : false,
                                        showStateColumn : false,
                                        showBranchOnGrouping : false
                                     };


    $(document).ready(function() {

        myGridID = AUIGrid.create("#main_grid_wrap", columnLayout, gridPros);
        myDetailGridID = AUIGrid.create("#detail_grid_wrap", detailLayout, detailGridPros);
        myBarScanGridID = AUIGrid.create("#barscan_grid_wrap", barScanLayout, barScanGridPros);
        mySerialGridID = AUIGrid.create("#serialdetail_grid_wrap", serialDetailLayout, serialGridPros);

        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {

            if(event.rowIndex > -1)
            {
                $("#main_grid_wrap").slideToggle(500);
                $("#deliverySection").show();

                $("#txtDelNo").val(AUIGrid.getCellValue(myGridID, event.rowIndex, "delno"));
                $("#txtReqstNo").val(AUIGrid.getCellValue(myGridID, event.rowIndex, "reqstno"));
                $("#txtCrtDt").val(AUIGrid.getCellValue(myGridID, event.rowIndex, "deldate"));
                $("#txtFrLoc").val(AUIGrid.getCellValue(myGridID, event.rowIndex, "frmloc"));
                $("#txtToLoc").val(AUIGrid.getCellValue(myGridID, event.rowIndex, "toloc"));

                $("#reqstno").val(AUIGrid.getCellValue(myGridID, event.rowIndex, "reqstno"));
                $("#reqstdt").val(AUIGrid.getCellValue(myGridID, event.rowIndex, "reqstdt"));
                $("#frmlocid").val(AUIGrid.getCellValue(myGridID, event.rowIndex, "frmlocid"));
                $("#tolocid").val(AUIGrid.getCellValue(myGridID, event.rowIndex, "tolocid"));

                fn_GetScanProgress();
            }
            else
            {
                Common.alert('Please select a row first.');
            }
        });

        AUIGrid.bind(myDetailGridID, "cellDoubleClick", function(event) {

            var itmCode = AUIGrid.getCellValue(myDetailGridID, event.rowIndex, "itmcode");
            var itmDesc = AUIGrid.getCellValue(myDetailGridID, event.rowIndex, "itmdesc");

            var data = { delno : $("#txtDelNo").val(), itmcode : itmCode };

            Common.ajaxSync("GET", "/logistics/SerialMgmt/selectSerialDetails.do", data, function(result) {

                AUIGrid.clearGridData(mySerialGridID);

                var gridData = result;

                AUIGrid.setGridData(mySerialGridID, gridData.data);

                $("#ItemDetails").text(itmCode + " - " + itmDesc);

                $("#popup_wrap, .popup_wrap").draggable({handle: '.pop_header'});

                $("#serialDetailWindow").show();

                AUIGrid.resize(mySerialGridID);

            }, function(jqXHR, textStatus, errorThrown) {

                    try { }
                    catch (e) { }

                    Common.alert("Fail : " + jqXHR.responseJSON.message);
                });
        });

        AUIGrid.bind(myBarScanGridID, "rowCheckClick", function(event) {

            var unitType = AUIGrid.getCellValue(myBarScanGridID, event.rowIndex, "unit");

            if(unitType == "Pal" || unitType == "Box")
            {
                var getSeqNo = AUIGrid.getCellValue(myBarScanGridID, event.rowIndex, "seqno");

                if(event.checked)
                {
                    AUIGrid.addCheckedRowsByValue(myBarScanGridID, "seqno", getSeqNo);
                }
                else
                {
                    AUIGrid.addUncheckedRowsByValue(myBarScanGridID, "seqno", getSeqNo);
                }
            }
        });

        $("#deliverySection").hide();

        fn_balanceDelivery();
        fn_ViewDeliveryList();

   });

    $(function() {

        $("#refresh").click(function() {

            if($("#main_grid_wrap").is(":visible"))
            {
                fn_balanceDelivery();
                fn_ViewDeliveryList();
            }
            else
            {
                fn_balanceDelivery();
                fn_ViewDeliveryList();

                $("#main_grid_wrap").slideToggle(300);
                $("#deliverySection").hide();
            }

        });


        $("#btnSave").click(function() {

            var RemainingQty = AUIGrid.getColumnValues(myDetailGridID, "remainqty");
            var ScanComplete = "1";

            for(var i = 0; i < RemainingQty.length; i++)
            {
                if (RemainingQty[i] != "0")
                {
                    ScanComplete = "0";
                }
            }

            if (ScanComplete == "1")
            {
                Common.alert("Confirm");
            }
            else
            {
                Common.alert("Please complete the scanning quantity needed for the Delivery No.")
            }
        });
    });


    function fn_showSerialRegistration()
    {
        var ItmCodeArray = AUIGrid.getColumnValues(myDetailGridID, "itmcode");
        var ItmCodeQty = AUIGrid.getColumnValues(myDetailGridID, "remainqty");

        ItmCodeMap = new Map();

        for (var i = 0; i < ItmCodeArray.length; i ++)
        {
            ItmCodeMap.set(ItmCodeArray[i], ItmCodeQty[i]);
        }

        $("#popup_wrap, .popup_wrap").draggable({handle: '.pop_header'});

        $("#txtBarcode").val('');

        AUIGrid.clearGridData(myBarScanGridID);

        SeqNo = 1;
        SeqGroup = 1;

        $("#barScanWindow").show();

        AUIGrid.resize(myBarScanGridID);

        $("#txtBarcode").focus();
    }


    function fn_ViewDeliveryList()
    {
        var data = {Type : "10"};
        Common.ajaxSync("GET", "/logistics/SerialMgmt/selectDeliveryList.do", data, function(result) {

            var gridData = result;

            AUIGrid.setGridData(myGridID, gridData.data);

        }, function (jqXHR, textStatus, errorThrown) {

            try { }
            catch (e) { }

            Common.alert("Fail : " + jqXHR.responseJSON.message);
        });
    }


    function fn_balanceDelivery()
    {
        var data = {Type : "10"};
        Common.ajaxSync("GET", "/logistics/SerialMgmt/selectDeliveryBalance.do", data, function(result) {

            $("#grCDC").val(result.data[0].grcdc);

        }, function (jqXHR, textStatus, errorThrown) {

            try { }
            catch (e) { }

            Common.alert("Fail : " + jqXHR.responseJSON.message);
        });
    }


    function fn_splitBarcode() {

        if($("#txtBarcode").val() != null || $("#txtBarcode").val() != '')
        {
            var BarCodeArray = $("#txtBarcode").val().match(/.{1,18}/g);

            var unitType;
            var hasBox = false;

            var ExistingBarCodeArray = AUIGrid.getColumnValues(myBarScanGridID, "boxno");

            for (var i = 0 ; i < BarCodeArray.length ; i++)
            {
                if (BarCodeArray[i].charAt(BarCodeArray[i].length - 5) == 'B')
                {
                    unitType = "Box";
                    hasBox = true;
                }
                else if (BarCodeArray[i].charAt(BarCodeArray[i].length - 5) == 'P')
                {
                    unitType = "Pal";
                    hasBox = true;
                }
                else
                {
                    unitType = "Ind";
                }

                if(ExistingBarCodeArray.includes(BarCodeArray[i]))
                {
                    BarCodeArray[i] = BarCodeArray[i] + " (Duplicate)";
                }

                if(unitType == "Ind")
                {
                   var items = {
                                           "seqno" : SeqNo,
                                           "itmcode" : "Serial No. Does Not Exist.",
                                           "boxno" : BarCodeArray[i],
                                           "unit" : unitType,
                                           "status" : "0",
                                           "serialno" : "-"
                                       }

                    SeqNo +=1;
                }
                else
                {
                    var items = {
                                            "seqno" : "G" + SeqGroup,
                                            "itmcode" : "Serial No. Does Not Exist.",
                                            "boxno" : BarCodeArray[i],
                                            "unit" : unitType,
                                            "status" : "0",
                                            "serialno" : "-"
                                        }
                }

                AUIGrid.addRow(myBarScanGridID, items, "last");
            }

            if(hasBox == true)
            {
                SeqGroup += 1;
            }

            var url = "/logistics/SerialMgmt/selectBoxNoList.do";

            var BoxNoArray = {"barcode" : BarCodeArray};

            Common.ajax("POST", url, BoxNoArray, function(data) {

                var myData = data;

                var serialno;
                var boxno;
                var status;
                var itmcode;
                var rowIndex;

                $.each(myData.data, function(key, value) {

                    boxno = myData.data[key]["boxno"];
                    rowIndex = AUIGrid.getRowIndexesByValue(myBarScanGridID, "boxno", boxno);

                    itmcode = myData.data[key]["itmcode"];
                    status = "1";

                    if(itmcode == "Serial Has Been Scanned.")
                    {
                        status = "0";
                    }


                    if(!ItmCodeMap.has(itmcode))
                    {
                        boxno = "Material is not in Delivery List.";
                        status = "0";
                    }

                    if(ItmCodeMap.has(itmcode) && status == "1")
                    {
                        var remainingQty =  parseInt(ItmCodeMap.get(itmcode));

                        if(remainingQty == 0)
                        {
                            boxno = "Exceeded Delivery Qty";
                            status = "0";
                        }
                        else
                        {
                            var newRemainingQty = (remainingQty - 1);

                                ItmCodeMap.set(itmcode, newRemainingQty);
                        }
                    }

                    if(status == 1)
                    {
                        serialno = myData.data[key]["serialno"];
                    }
                    else
                    {
                        serialno = "-";
                    }

                    var items = {
                                          "boxno" : boxno,
                                          "itmcode" : itmcode,
                                          "status" :   status,
                                          "serialno" : serialno
                                       }

                    AUIGrid.updateRow(myBarScanGridID, items, rowIndex);

                });

                AUIGrid.update(myBarScanGridID);
            });

            AUIGrid.setProp(myBarScanGridID, "rowStyleFunction", function(rowIndex, item) {

                    if(item.status == "0")
                    {
                        return "my-row-style";
                    }

                    return "";
                });

            $("#txtBarcode").val('');
            $("#txtBarcode").focus();
        }
        else
        {
            Common.alert("Please Try Scanning Again.");
        }
    }


    function fn_confirmScanItem()
    {
        var totalError = AUIGrid.getRowIndexesByValue(myBarScanGridID, "status", "0") + 1;
        var totalRows = AUIGrid.getRowCount(myBarScanGridID);

        if(totalError.length > 1)
        {
            Common.alert("Please ensure that all scannings are valid.");
        }
        else if(totalRows < 1)
        {
            Common.alert("Please scan an item before confirming.");
        }
        else
        {
            var GridData = AUIGrid.getAddedRowItems(myBarScanGridID);
            var FormData = $("#GICDCForm").serializeJSON();
            var data = {};

            data.add = GridData;
            data.form = FormData;

            var url = "/logistics/SerialMgmt/insertScanItems.do";

            Common.ajax("POST", url, data, function(result) {

                var gridData = result;

                AUIGrid.setGridData(myDetailGridID, gridData.data);

                $("#barScanWindow").hide();

            },  function(jqXHR, textStatus, errorThrown) {

                    try { }
                    catch (e) { }

                    Common.alert("Fail : " + jqXHR.responseJSON.message);
            });
        }
    }


    function fn_deleteScanItem()
    {
        var DeleteItems = AUIGrid.getCheckedRowItemsAll(myBarScanGridID);

        for(var i = 0; i < DeleteItems.length; i ++)
        {
            var itmCode = DeleteItems[i].itmcode;
            var itmStatus = DeleteItems[i].status;

            if(ItmCodeMap.has(itmCode) && itmStatus == "1")
            {
                var remainingQty = parseInt(ItmCodeMap.get(itmCode));

                var newRemainingQty = remainingQty + 1;

                ItmCodeMap.set(itmCode, newRemainingQty)
            }
        }

        AUIGrid.removeCheckedRows(myBarScanGridID);
        AUIGrid.removeSoftRows(myBarScanGridID);
    }


    function fn_GetScanProgress()
    {
        var data = {"delno" : $("#txtDelNo").val()};

        Common.ajaxSync("GET", "/logistics/SerialMgmt/selectScanList.do", data, function(result) {

            var gridData = result;

            AUIGrid.setGridData(myDetailGridID, gridData.data);

        }, function(jqXHR, textStatus, errorThrown) {

                try { }
                catch (e) { }

                Common.alert("Fail : " + jqXHR.responseJSON.message);
            });

        AUIGrid.resize(myDetailGridID);
    }

</script>

<section id="content"><!-- content start -->

    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Logistics</li>
        <li>S/N Management</li>
        <li>Goods Receipt (CDC)</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Serial No. Scanning (Goods Receipt CRC)</h2>
    </aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->

        <form id="searchForm" name="searchForm">

            <table class="type1"><!-- table start -->

                <caption>table</caption>

                <colgroup>
                    <col style="width:200px" />
                    <col style="width:80px" />
                </colgroup>

                <tbody>
                    <tr>
                        <th scope="row">Active Delivery No.</th>
                        <td>
                            <input type="text"  id="grCDC" name="grCDC"  class="w100p"  readonly/>
                        </td>
                        <td>
                            <p class="btn_blue"><a id="refresh">Refresh</a></p>
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
		&nbsp;
		&nbsp;
    </section><!-- search_table end -->

    <section class="search_result"><!-- search_result start -->

        <div id="main_grid_wrap" class="mt10" style="height:430px"></div>

    </section><!-- search_result end -->


    <section class="search_table" id="deliverySection"><!-- search_table start -->

        <aside class="title_line">
            <h2>Delivery No. Details</h2>
        </aside>

        <form id="GICDCForm" name="GICDCForm">

            <input type="hidden" id="reqstno" name="reqstno"/>
            <input type="hidden" id="reqstdt" name="reqstdt"/>
            <input type="hidden" id="frmlocid" name="frmlocid"/>
            <input type="hidden" id="tolocid" name="tolocid"/>
            <input type="hidden" id="scantype" name="scantype" value="10" />

            <table class="type1"><!-- table start -->

                <caption>table</caption>

                <colgroup>
                    <col style="width:110px" />
                    <col style="width:250px" />
                    <col style="width:110px" />
                    <col style="width:250px" />
                    <col style="width:*" />
                </colgroup>

                <tbody>
                    <tr>
                        <th scope="row">Delivery No.</th>
                        <td>
                            <input type="text" id="txtDelNo" name="txtDelNo"  class="w100p"  readonly/>
                        </td>
                        <th scope="row">Request No.</th>
                        <td>
                            <input type="text" id="txtReqstNo" name="txtReqstNo"  class="w100p"  readonly/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Create Date</th>
                        <td>
                            <input type="text"  id="txtCrtDt" name="txtCrtDt"  class="w100p"  readonly/>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">From Location</th>
                        <td>
                            <input type="text"  id="txtFrLoc" name="txtFrLoc"  class="w100p"  readonly/>
                        </td>
                        <th scope="row">To Location</th>
                        <td>
                            <input type="text"  id="txtToLoc" name="txtToLoc"  class="w100p"  readonly/>
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->

            &nbsp;
            <ul class="left_btns">
<c:if test="${PAGE_AUTH.funcView == 'Y'}">
                <li><p class="btn_blue"><a onclick="javascript:fn_showSerialRegistration();">Scan Barcode</a></p></li>
</c:if>            
<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
                <li><p class="btn_blue"><a id="btnSave">SAVE</a></p></li>
</c:if>
            </ul>

            &nbsp;
            <div id="detail_grid_wrap"  style="height:200px;width:59.5%;"></div>

        </form>

    </section><!-- search_table end -->


    <div class="popup_wrap" id="barScanWindow" style="display:none; width:51%;"><!-- popup_wrap start -->

        <header class="pop_header">

            <h1>Serial No. Registration</h1>
                <ul class="right_opt">
                    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
                </ul>

        </header>

        <section class="pop_body"><!-- pop_body start -->

            <form id="barScanForm" name="barScanForm" method="POST">

                <table class="type1"><!-- table start -->

                    <caption>search table</caption>

                    <colgroup>
                    <col style="width:140px" />
                    </colgroup>

                    <tbody>
                        <tr>
                            <th scope="row"><b>BARCODE</b></th>
                            <td>
                                 <input type="text"  id="txtBarcode" name="txtBarcode"
                                            onchange="javascript:fn_splitBarcode();"
                                            placeholder="Please select here before scanning."
                                            style="height:40px;width:340px;" />
                            </td>
                        </tr>
                     </tbody>
                </table><!-- table end -->

                &nbsp;
                <div id="barscan_grid_wrap" style="height:350px;"></div>
                &nbsp;

                <ul class="center_btns">
<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
                    <li><p class="btn_blue2 big"><a onclick="javascript:fn_confirmScanItem();">Confirm</a></p></li>
                    <li><p class="btn_blue2 big"><a onclick="javascript:fn_deleteScanItem();">Delete Checked Items</a></p></li>
</c:if>                
                </ul>

            </form>
        </section>
    </div>


    <div class="popup_wrap" id="serialDetailWindow" style="display:none; width:56%;"><!-- popup_wrap start -->

        <header class="pop_header">

            <h1>Serial No. Details</h1>
                <ul class="right_opt">
                    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
                </ul>

        </header>

        <section class="pop_body"><!-- pop_body start -->

            <form id="serialForm" name="serialForm" method="POST">

                <h3 id="ItemDetails"></h3>
                &nbsp;
                <div id="serialdetail_grid_wrap" style="height:400px"></div>

            </form>
        </section>
    </div>
</section><!-- content end -->