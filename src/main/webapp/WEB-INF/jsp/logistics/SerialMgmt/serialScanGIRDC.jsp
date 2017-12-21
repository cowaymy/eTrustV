<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">


    #barScanWindow { font-size:20px; }
    #barScanWindow label, input { display:inline; }
    #barScanWindow input.text { margin-bottom:10px; width:95%; padding: 0.1em;  font-size:20px;}
    #barScanWindow fieldset { padding:0; border:0; margin-top:10px; }

    .my-row-style { background:#FF5733; font-weight:bold; color:#22741C; }

</style>

<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>

<script type="text/javaScript" language="javascript">

    var myRDCGridID;
    var myBarScanGridID;

    var SeqNo;
    var SeqGroup;

    var RDCLayout = [
                                  {dataField:"scanno", headerText:"Scan No.", width:135, height:30},
                                  {dataField:"seq", headerText:"Seq No.", width:80, height:30},
                                  {dataField:"serialno", headerText:"Serial No.", width:180, height:30},
                                  {dataField:"itmcode", headerText:"Item Code", width:130, height:30},
                                  {dataField:"itmdesc", headerText:"Item Description", width:300, height:30},
                                  {dataField:"scanstus", headerText:"Scan Status", width:90, height:30},
                                  {dataField:"reqstdt", headerText:"Request Date", width:120, height:30},
                                  {dataField:"frmloc", headerText:"From Location", width:220, height:30},
                                  {dataField:"toloc", headerText:"To Location", width:220, height:30},
                                  {dataField:"crt", headerText:"Creator", width:110, height:30},
                                  {dataField:"crtdt", headerText:"Created Date", width:120, height:30}
                                ];

    var barScanLayout = [
                         {dataField:"seqno", headerText:"Seq No.", width:70, height:30},
                         {dataField:"itmcode", headerText:"Item Code", width:110, height:30},
                         {dataField:"boxno", headerText:"Box No.", width:230, height:30},
                         {dataField:"unit", headerText:"Unit", width:60, height:30},
                         {dataField:"status", headerText:"Status", width:40, height:30, visible:false},
                         {dataField:"serialno", headerText:"Serial No", width:40, height:30, visible:false}
                                      ];


    var RDCGridPros = {
                                      groupingFields : ["scanno"],
                                      enableCellMerge : true,
                                      editable : false,
                                      showRowCheckColumn : false,
                                      showStateColumn : false,
                                      showBranchOnGrouping : false,
                                      scrollHeight4Mobile : true,
                                      autoScrollSize: true
                                   };

    var barScanGridPros = {
                                            editable : false,
                                            showRowCheckColumn : true,
                                            showRowAllCheckBox : false,
                                            showStateColumn : false,
                                            showBranchOnGrouping : false,
                                            scrollHeight4Mobile : true,
                                            autoScrollSize: true
                                         };


    $(document).ready(function() {

        myRDCGridID = AUIGrid.create("#rdc_grid_wrap", RDCLayout, RDCGridPros);
        myBarScanGridID = AUIGrid.create("#barscan_grid_wrap", barScanLayout, barScanGridPros);

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

        fn_getUserLocDetails();

        fn_ViewRDCScanList();

        fn_balanceGIRDC();

    });


    $(function() {

        $("#refresh").click(function() {

        	fn_ViewRDCScanList();
            fn_balanceGIRDC();
        });

    });

    function fn_getUserLocDetails()
    {
         var data = {};

         Common.ajaxSync("GET", "/logistics/SerialMgmt/selectUserDetails.do", data, function(result) {

             var userDetails = result.data;

             $("#RDCFrmLocID").val(userDetails[0].locid);
             $("#RDCFrmLoc").val(userDetails[0].locdesc);

             var paramdata = { rdcloc:$("#RDCFrmLocID").val(), locgb:'CT'};
             doGetComboCodeId('/common/selectStockLocationList.do', paramdata, '', 'RDCToLoc', 'S', '');

             doSysdate(0 , "reqstDt");

         }, function(jqXHR, textStatus, errorThrown) {

             try { }
             catch (e) { }

             Common.alert("Fail : " + jqXHR.responseJSON.message);
         });
    }


    function fn_ViewRDCScanList()
    {
         var data = {};

         Common.ajaxSync("GET", "/logistics/SerialMgmt/selectRDCScanList.do", data, function(result) {

             var gridData = result;

             AUIGrid.setGridData(myRDCGridID, gridData.data);

         }, function(jqXHR, textStatus, errorThrown) {

             try { }
             catch (e) { }

             Common.alert("Fail : " + jqXHR.responseJSON.message);
         });
    }


    function fn_showSerialRegistration()
    {
        if ($("#RDCToLoc").val() == ''|| $("#RDCToLocID").val() == '')
        {
           Common.alert("Please select a location to delivery before proceeding.");
        }
        else
        {
            $("#popup_wrap, .popup_wrap").draggable({handle: '.pop_header'});

            $("#txtBarcode").val('');
            AUIGrid.clearGridData(myBarScanGridID);

            SeqNo = 1;
            SeqGroup = 1;

            $("#barScanWindow").show();

            AUIGrid.resize(myBarScanGridID);

            $("#txtBarcode").focus();
        }
    }


    function fn_balanceGIRDC()
    {
        var data = {};
        Common.ajaxSync("GET", "/logistics/SerialMgmt/selectGIRDCBalance.do", data, function(result) {

            $("#giRDC").val(result.data[0].girdc);

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
                    itmcode = myData.data[key]["itmcode"];
                    status = "1";

                    rowIndex = AUIGrid.getRowIndexesByValue(myBarScanGridID, "boxno", boxno);

                    if(itmcode == "Serial Has Been Scanned.")
                    {
                        status = "0";
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
            var FormData = $('#GIRDCForm').serializeJSON();
            var data = {};

            data.add = GridData;
            data.form = FormData;

            var url = "/logistics/SerialMgmt/insertScanItems.do";

            Common.ajax("POST", url, data, function(result) {

                $("#barScanWindow").hide();

                Common.alert("Scanned Item(s) Saved.");

            },  function(jqXHR, textStatus, errorThrown) {

                    try { }
                    catch (e) { }

                    Common.alert("Fail : " + jqXHR.responseJSON.message);
            });
        }
    }


    function fn_deleteScanItem()
    {
        AUIGrid.removeCheckedRows(myBarScanGridID);
        AUIGrid.removeSoftRows(myBarScanGridID);
    }

</script>

<section id="content"><!-- content start -->

    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>Logistics</li>
        <li>S/N Management</li>
        <li>Goods Issue (RDC)</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Serial No. Scanning (Goods Issue RDC)</h2>
    </aside><!-- title_line end -->

    <section class="search_table"><!-- search_table start -->

        <form id="searchForm" name="searchForm">

            <table class="type1"><!-- table start -->

                <caption>table</caption>

                <colgroup>
                    <col style="width:100px" />
                    <col style="width:80px" />
                </colgroup>

                <tbody>
                    <tr>
                        <th scope="row">Active GI</th>
                        <td>
                            <input type="text" id="giRDC" name="giRDC"  class="w100p" readonly />
                        </td>
                        <td>
                            <p class="btn_blue"><a id="refresh">Refresh</a></p>
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>

    </section><!-- search_table end -->


    <section class="search_table" id="RDCSection"><!-- search_table start -->

        <aside class="title_line">
            <h2>Delivery No. Details</h2>
        </aside>

        <form id="GIRDCForm" name="GIRDCForm">

            <input type="hidden" id="RDCFrmLocID" name="RDCFrmLocID"/>
            <input type="hidden" id="scantype" name="scantype" value="30" />
            <input type="hidden" id="svalue" name="svalue"/>
            <input type="hidden" id="sUrl"   name="sUrl"  />
            <input type="hidden" id="stype"  name="stype" />

            <table class="type1"><!-- table start -->

                <caption>table</caption>

                <colgroup>
                    <col style="width:150px" />
                    <col style="width:250px" />
                    <col style="width:150px" />
                    <col style="width:250px" />
                    <col style="width:150px" />
                </colgroup>

                <tbody>
                    <tr>
                        <th scope="row">Request Date</th>
                        <td>
                            <input id="reqstDt"  name="reqstDt" type="text" title="Reqest Date" placeholder="DD/MM/YYYY" class="j_date" readonly />
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">From Location</th>
                        <td>
                            <input type="text"  id="RDCFrmLoc" name="RDCFrmLoc"  class="w100p"  readonly />
                        </td>
                        <th scope="row">To Location</th>
                        <td>
                            <select class="w100p" id="RDCToLoc" name="RDCToLoc"></select>
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->

            &nbsp;
            <ul class="left_btns">
                <li><p class="btn_blue"><a onclick="javascript:fn_showSerialRegistration();">Scan Barcode</a></p></li>
            </ul>

            &nbsp;
            <div id="rdc_grid_wrap"  style="height:350px"></div>

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
                    <li><p class="btn_blue2 big"><a onclick="javascript:fn_confirmScanItem();">Confirm</a></p></li>
                    <li><p class="btn_blue2 big"><a onclick="javascript:fn_deleteScanItem();">Delete Checked Items</a></p></li>
                </ul>

            </form>
        </section>
    </div>
</section><!-- content end -->