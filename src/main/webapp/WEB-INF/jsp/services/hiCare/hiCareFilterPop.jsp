<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

    //AUIGrid 생성 후 반환 ID
    var listGiftGridID;

    var MEM_TYPE = '${SESSION_INFO.userTypeId}';
    var BranchId = '${SESSION_INFO.userBranchId}';
    var returnStatusOption = [{"codeId": "494","codeName": "Stock Return"},{"codeId": "495","codeName": "Condition Update"}];
    var returnConditionOption = [{"codeId": "111","codeName": "Used"},{"codeId": "112","codeName": "Defect"}];

    $(document).ready(function(){

    	setText();

    	doGetComboOrder('/common/selectCodeList.do', '497', 'CODE_ID', '', 'filterReason', 'S', ''); //Common Code

    	$("#usedFilterTxtBarcode").change(function() {
            event.preventDefault();
            fn_splitUsedBarcode();
        });

        //$("#usedFilterTxtBarcode").focus();

        $("#newFilterTxtBarcode").change(function() {
            event.preventDefault();
            fn_splitBarcode();
        });
    });

    function setText(result){
    	 var date = new Date(Date.now());
    	 $("#serialNoTxt").html('${headerDetail.serialNo}');
    	 $("#serialNoChg").val('${headerDetail.serialNo}');
    	 $("#model").html('${headerDetail.model}');
    	 $("#status").html('${headerDetail.status}');
    	 $("#condition").html('${headerDetail.condition}');
    	 $("#filterSn").html('${headerDetail.filterSn}');
    	 $("#filterChgDt").html('${headerDetail.filterChgDt}');
    	 $("#holderLoc").html('${headerDetail.holderLoc}');
    	 $("#changeDt").html(date.toLocaleString('en-GB', { hour12:false }));
    }

    function fn_splitUsedBarcode(){
    	 if($("#usedFilterTxtBarcode").val() != null || js.String.strNvl($("#usedFilterTxtBarcode").val()) != ""){
    	        var BarCodeArray = $("#usedFilterTxtBarcode").val().toUpperCase().match(/.{1,18}/g);

    	        var unitType = "EA";
    	        var failSound = false;
    	        var rowData = {};
    	        var barInfo = [];
    	        var boxInfo = [];
    	        var stockCode = "";

    	        console.log("BarCodeArray " + BarCodeArray);
    	        console.log("BarCodeArray.length " + BarCodeArray.length);
    	        for (var i = 0 ; i < BarCodeArray.length ; i++){
    	            console.log("BarCodeArray[i] " + BarCodeArray[i]);

    	            if( BarCodeArray[i].length < 18 ){
    	                failSound = true;
    	                Common.alert("Serial No. less than 18 characters.");
    	                $("#usedFilterTxtBarcode").val("");
                        $("#usedFilterTxtBarcode").focus();
    	                continue;
    	            }

    	            stockCode = (js.String.roughScale(BarCodeArray[i].substr(3,5), 36)).toString();

    	            if(stockCode == "0"){
    	                failSound = true;
    	                Common.alert("Serial No. Does Not Exist.");
    	                $("#usedFilterTxtBarcode").val("");
    	                $("#usedFilterTxtBarcode").focus();
    	                continue;
    	            }

    	             /* barInfo.push({   "serialNo":BarCodeArray[i]
    	                           , "branchCode":$('#cmdBranchCode1').val()
    	                           , "model":$('#cmbModel1').val()
    	                           , "transactionType":'H1'
    	                           , "stockCode":stockCode
    	                           , "scanNo":$('#scanNo').val()
    	                         }); */
    	        }

    	        /* if(barInfo.length > 0){
    	            Common.ajax("POST", "/services/hiCare/saveHiCareBarcode.do"
    	                    , {"barList":barInfo}
    	                    , function(result){
    	                        $.each(result.dataList, function(idx, row){
    	                            if(row.status == 0){
    	                                failSound = true;
    	                            }
    	                            if(js.String.isNotEmpty(row.scanNo)){
    	                                $("#scanNo").val(row.scanNo);
    	                            }

    	                            AUIGrid.addRow(scanGridId, row, "first");
    	                        });

    	                        if(!msIe){
    	                            if(failSound){
    	                                //beep(999, 210, 800); beep(999, 500, 800);
    	                                $("#txtBarcode").val("");
    	                                $("#txtBarcode").focus();
    	                            }else{
    	                                //beep(100, 520, 200);
    	                                $("#txtBarcode").val("");
    	                                $("#txtBarcode").focus();
    	                            }
    	                        }
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
    	                        //Common.alert("Fail : " + jqXHR.responseJSON.message);
    	                    });
    	        }else{
    	            // faile sound
    	            if(!msIe){
    	                //beep(999, 210, 800); beep(999, 500, 800);
    	                $("#txtBarcode").val("");
    	                $("#txtBarcode").focus();
    	            }
    	        } */
    	    }
    }

    function fn_checkEmpty(){
        var checkResult = true;

        var isCheck = document.getElementById("checkReturn").checked;
        if(isCheck && FormUtil.isEmpty($("#usedFilterTxtBarcode").val()) ) {
            Common.alert('Please key in Used Filter Serial No.');
            checkResult = false;
            return checkResult;
        }else if(FormUtil.isEmpty($("#newFilterTxtBarcode").val()) ) {
            Common.alert('Please key in New Filter Serial No.');
            checkResult = false;
            return checkResult;
        }else if(FormUtil.isEmpty($("#filterReason").val()) ) {
            Common.alert('Please select reason.');
            checkResult = false;
            return checkResult;
        }else if(FormUtil.isEmpty($("#filterRemarks").val()) && $("#filterReason").val() == '6642') {
            Common.alert('Please fill in remark.');
            checkResult = false;
            return checkResult;
        }

        return checkResult;
    }

    $(function(){
        $('#btnSave').click(function() {
            console.log("btnSave clicked")
            var checkResult = fn_checkEmpty();
            if(!checkResult) {
                return false;
            }

            fn_doSaveHiCareEdit();

        });
    });

    function fn_doSaveHiCareEdit(){
        var data;

        //document.getElementById("checkReturn").checked
		data = $("#editArea1Form").serializeJSON();
		$.extend(data,
        {
			"serialNo":$("#serialNoChg").val()
			, "isReturn":document.getElementById("checkReturn").checked
        }
        );

		 if(Common.confirm("Do you want to save?", function(){
	     	Common.ajax("POST", "/services/hiCare/saveHiCareFilter.do", data, function(result) {
	             console.log( result);

	             if(result == null){
	                 Common.alert("Record cannot be update.");
	             }else{
	                 Common.alert("Record has been updated.");
	                 $('#filterPop').remove();
	                 $("#search").click();
	                 window.close();
	             }
	        });
		 }));
    }

    function fn_close() {
        $("#popup_wrap").remove();
    }

    function fn_closePreOrdModPop() {
        myFileCaches = {};
        delete update;
        delete remove;
        $('#filterPop').remove();
    }
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Hi-Care Movement</h1>
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
            <table class="type1">
                <!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width: 140px" />
                    <col style="width: *" />
                    <col style="width: 140px" />
                    <col style="width: *" />
                    <col style="width: 180px" />
                    <col style="width: *" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Serial No.</th>
                        <td colspan="3"><span id='serialNoTxt' ></span></td>
                        <th scope="row">Model</th>
                        <td colspan="3"><span id='model' ></span></td>
                    </tr>
                    <tr>
                        <th scope="row">Status</th>
                        <td colspan="3"><span id='status' ></span></td>
                        <th scope="row">Condition</th>
                        <td colspan="3"><span id='condition' ></span></td>
                    </tr>
                    <tr>
                        <th scope="row">Sediment Filter Serial No.</th>
                        <td colspan="3"><span id='filterSn' ></span></td>
                        <th scope="row">Filter Last Change Date</th>
                        <td colspan="3"><span id='filterChgDt' ></span></td>
                    </tr>
                    <tr>
                        <th scope="row">Member Code</th>
                        <td colspan="3"><span id='holderLoc' ></span></td>
                        <th scope="row">Change Date</th>
                        <td colspan="3"><span id='changeDt' ></span></td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>

</section>
<section id="editArea" class="">

<aside class="title_line">
    <h3>Edit Info</h3>
</aside>
<form id="editArea1Form" name="editArea1Form" action="#" method="post">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Used Sediment Filter Serial No. <span class="must">*</span></th>
        <td>
            <!-- <select id="usedFilter" name="usedFilter" class="w100p"> -->
            <input type="text"  id="usedFilterTxtBarcode" name="usedFilterTxtBarcode" placeholder="Please select here before scanning." style="height:40px;width:99%; text-transform:uppercase;" />
        </td>
</tr>
<tr>
    <th scope="row">New Sediment Filter Serial No. <span class="must">*</span></th>
    <td>
        <!-- <select id="newFilter" name="newFilter" class="w100p"> -->
        <input type="text"  id="newFilterTxtBarcode" name="newFilterTxtBarcode" placeholder="Please select here before scanning." style="height:40px;width:99%; text-transform:uppercase;" />
    </td>
    <th scope="row">Used Has Return<span class="must">*</span></th>
    <td><label><input type="checkbox" id="checkReturn" name="checkReturn" /></label></td>
</tr>
<tr>
    <th scope="row">Reason<span class="must">*</span></th>
    <td>
        <select id="filterReason" name="filterReason" class="w100p">
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.remark" /></th>
    <td>
        <textarea cols="20" id="filterRemark" name="filterRemark" placeholder="Remark"></textarea>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<input type="hidden" name="serialNoChg" id="serialNoChg" value="${headerDetail.serialNo}"/>

<ul class="center_btns mt20">
    <li><p class="btn_blue2 big"><a id="btnSave" href="#">Save</a></p></li>
</ul>
</section>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
