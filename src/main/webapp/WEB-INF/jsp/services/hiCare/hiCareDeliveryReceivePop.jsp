<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style>
.my-row-style { background:#FF5733; font-weight:bold; color:#22741C;}
.aui-grid-link-renderer1 {
      text-decoration:underline;
      color: #4374D9 !important;
      cursor: pointer;
      text-align: right;
    }
</style>
<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var gridHistID;
    var gridTrfID;
    var update = new Array();
    var remove = new Array();
    var myFileCaches = {};
    var deactAtchFileId = 0;
    var deactAtchFileName = "";

    var MEM_TYPE = '${SESSION_INFO.userTypeId}';
    var BranchId = '${SESSION_INFO.userBranchId}';
    $(document).ready(function(){

    	hiCareGrid();

    	setText();

    	fn_clearSerialFirst();

    	fn_transitListAjax();

    	$("#btnPopSerial").click(function(){
    		var transitNo = '${headerDetail.transitNo}';
            Common.popupDiv("/services/hiCare/hiCareSerialScanPop.do", {transitNo : transitNo}, null, true, 'serialScanPop');
        });

    	$('#btnPopSearch').click(function(){
    		fn_transitListAjax();
        });
    });

    function fn_transitListAjax(){
    	console.log("btnPopSearch clicked");
        var transitNo = $("#transitNoTxt").html();
        Common.ajax("GET", "/services/hiCare/selectHiCareDeliveryDetail", {transitNo : transitNo},function(result) {
            AUIGrid.setGridData(gridHistID, result);
          });
    }

    function fn_clearSerialFirst() {
        var transitNo = $("#transitNoTxt").html();
        Common.ajaxSync("POST", "/services/hiCare/deleteHiCareDeliverySerial.do"
                        , {"transitNo": transitNo}
                        , function(result){

                                  }
                                 , function(jqXHR, textStatus, errorThrown){
                                     try{
                                         console.log("Fail Status : " + jqXHR.status);
                                         console.log("code : "        + jqXHR.responseJSON.code);
                                         console.log("message : "     + jqXHR.responseJSON.message);
                                         console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
                                     }catch (e){
                                         console.log(e);
                                     }
                                     Common.alert("Fail : " + jqXHR.responseJSON.message);
                         });
    }

    function hiCareGrid() {

        var bodyLayout = [ {
          dataField : "serialNo",
          headerText : "Serial No.",
          width : "20%"
        }, {
          dataField : "modelName",
          headerText : "Model",
          width : "10%"
        }, {
            dataField : "statusDesc",
            headerText : "status",
            width : "10%"
        }, {
            dataField : "conditionDesc",
            headerText : "<spring:message code='service.grid.condition'/>",
            width : "10%"
        }, {dataField:"finalCmplt", headerText:"Scaned(Request)", width:160
            , style:"aui-grid-user-custom-right"
                , dataType:"numeric"
                , formatString:"#,##0"
                , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField){
                    if(item.finalCmplt == 'N'){
                        return "my-row-style";
                    } else if(item.finalCmplt == 'Y'){
                        return "aui-grid-link-renderer1";
                    }
                }
            }
        ];

        var bodyGridPros = {
          usePaging : true,
          pageRowCount : 8,
          showStateColumn : false,
          displayTreeOpen : false,
          //selectionMode : "singleRow",
          skipReadonlyColumns : true,
          wrapSelectionMove : true,
          showRowNumColumn : true,
          editable : false
        };

        gridHistID = GridCommon.createAUIGrid("transitDetails_grid_wrap", bodyLayout, "", bodyGridPros);
    }

    function setText(result){
    	 $("#transitNoTxt").html('${headerDetail.transitNo}');
    	 $("#ztransitNo").val('${headerDetail.transitNo}');
    	 $("#transitStatus").html('${headerDetail.status}');
    	 $("#transFrom").html('${headerDetail.fromLocation}');
    	 $("#transTo").html('${headerDetail.toLocation}');
    	 $("#transDate").html('${headerDetail.crtDt}');
    	 $("#receiveDate").html('${headerDetail.recieveDt}');
    	 $("#qty").html('${headerDetail.qty}');
    	 $("#courier").html('${headerDetail.courier}');

    	 AUIGrid.setGridData(gridHistID, $.parseJSON('${bodyDetail}'));
    }



    $(function(){
        $('#btnSave').click(function() {
            console.log("btnSave clicked")
            var checkResult = fn_checkEmpty();
            if(!checkResult) {
                return false;
            }

            fn_doSaveHiCareTransit();

        });
    });

    function fn_checkEmpty(){
        var checkResult = true;

        var check = GridCommon.getGridData(gridHistID);
        for(var i = 0 ; i < check.all.length ; i++){
        	if (check.all[i].finalCmplt != 'Y'){
                Common.alert("Scan(Request) Qty haven't complete.")
               return false;
            }
        }
        return checkResult;
    }

    function fn_doSaveHiCareTransit(){

    	var data = $("#headForm").serializeJSON();

    	Common.ajax("POST", "/services/hiCare/saveHiCareDelivery.do", data, function(result) {
            console.log( result);

            if(result == null){
                Common.alert("Record cannot be update.");
            }else{
                Common.alert("Record has been updated.");
                $('#receivePop').remove();
                $("#search").click();
                window.close();
            }
       });
    }

    function fn_close() {
        $("#popup_wrap").remove();
    }

    function fn_closePreOrdModPop() {
        $('#excPop').remove();
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Transit Receive View</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnPreOrdClose" onClick="javascript:fn_closePreOrdModPop();" href="#">CLOSE | TUTUP</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<section id="headerArea" class="">
<aside class="title_line">
        <h3>Header Info</h3>
    </aside>
<form id="headForm" name="headForm" method="post">
	<input type="hidden" name="ztransitNo" id="ztransitNo"/>
            <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width: 140px" />
                    <col style="width: *" />
                    <col style="width: 140px" />
                    <col style="width: *" />
                    <col style="width: 140px" />
                    <col style="width: *" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Transit No.</th>
                        <td colspan="2"><span id='transitNoTxt' ></span></td>
                        <th scope="row">Transit Status</th>
                        <td colspan="2"><span id='transitStatus' ></span></td>
                    </tr>
                    <tr>
                        <th scope="row">Transit From</th>
                        <td colspan="2"><span id='transFrom' ></span></td>
                        <th scope="row">Transit To</th>
                        <td colspan="2"><span id='transTo' ></span></td>
                    </tr>
                    <tr>
                        <th scope="row">Transit Date</th>
                        <td colspan="2"><span id='transDate' ></span></td>
                        <th scope="row">Receive Date</th>
                        <td colspan="2"><span id='receiveDate' ></span></td>
                    </tr>
                    <tr>
                        <th scope="row">Total Transit</th>
                        <td colspan="2"><span id='qty' ></span></td>
                        <th scope="row">Courier</th>
                        <td colspan="2"><span id='courier' ></span></td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>

</section>

<aside class="title_line">
        <h3>Transit Details</h3>
        <ul class="right_btns">
            <li style="display:none;"><p class="btn_grid"><a id="btnPopSearch">Search</a></p></li>
            <li><p class="btn_grid"><a id="btnPopSerial">Serial Scan</a></p></li>
       </ul>
    </aside>
<article class="grid_wrap" id="hi_grid_wrap">
<!-- grid_wrap start  그리드 영역-->
    <div id="transitDetails_grid_wrap" style="width: 100%; margin: 0 auto;"></div>
</article>

<ul class="center_btns mt20">
    <li><p class="btn_blue2 big"><a id="btnSave" href="#">Save</a></p></li>
</ul>


</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
