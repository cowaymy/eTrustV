<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript" language="javascript">

    var stckGridID;

    $(document).ready(function(){

    	createAUIGridStk();
        fn_loadProductData();

        fn_selectPromotionListByStk(stkId);
        fn_getEKeyinQuota();
        fn_getAdminKeyinQuota();

        fn_chgPageMode('VIEW');

        if(AUTH_CHNG != "Y") {
            $("#btnProductEdit").addClass("blind");
            $("#btnProductSave").addClass("blind");
        }

    });

    function createAUIGridStk() {

        var columnLayout1 = [
           { headerText : "ON/OFF", dataField : "ctrlFlag",   width : '10%'
              ,renderer : { type : "CheckBoxEditRenderer",checkValue : "1",unCheckValue : "0", editable : true } }
          , { headerText : "<spring:message code='sales.promo.promoCd'/>", editable : false , dataField : "promoCode",   width :'20%' }
          , { headerText : "<spring:message code='sales.promo.promoNm'/>", editable : false , dataField : "promoDesc", width :'30%' }
          , { headerText : "<spring:message code='sal.text.quota'/>",      editable : true  , dataField : "ctrlQuota", width :'20%' }
          , { headerText : "promoId" , dataField : "promoId" , visible : false }
          , { headerText : ""        , dataField : "", width :'20%' }
          ];

        var gridPros = {
            usePaging           : true,
            pageRowCount        : 10,
            editable            : false,
            fixedColumnCount    : 1,
            showStateColumn     : false,
            displayTreeOpen     : false,
            softRemoveRowMode   : false,
            headerHeight        : 30,
            useGroupingPanel    : false,
            skipReadonlyColumns : true,
            wrapSelectionMove   : true,
            showRowNumColumn    : true,
            noDataMessage       : "No promotion found.",
            groupingMessage     : "Here groupping"
        };

        stckGridID = GridCommon.createAUIGrid("pop_stck_grid_wrap", columnLayout1, "", gridPros);
    }

    function fn_selectPromotionListByStk(stkId) {
        Common.ajax("GET", "/sales/productMgmt/selectPromotionListByStkId.do", {stkId : stkId}, function(result) {
            AUIGrid.setGridData(stckGridID, result);
        });
    }

    $(function(){

        $('#btnProductEdit').click(function() {
            fn_chgPageMode('MODIFY');
        });
        $('#btnClosePop').click(function(){
        	$('#modifyForm')[0].reset();
        	fn_selectProductMgmtListAjax();
        })
        $('#btnProductSave').click(function() {
        	var data = {};

        	data.form = $('#modifyForm').serializeJSON();
        	data.grid = AUIGrid.getEditedRowItems(stckGridID);

        	console.log(data);

        	Common.ajax("POST", "/sales/productMgmt/updateProductCtrl.do", data , function(result) {
        	    Common.alert("Saved",$('#btnClosePop').click());
        	});
        });

        $('#quota_ekeyin_stus').change(function() {

        }).multipleSelect({width: '100%',},"checkAll");

        $('#quota_admin_stus').change(function() {

        }).multipleSelect({width: '100%',},"checkAll");

        $('#btnCountAdminQuota').click(function(){
        	fn_getAdminKeyinQuota();
        });

        $('#btnCountEkeyinQuota').click(function(){
        	fn_getEKeyinQuota();
        });
    });

    function fn_chgPageMode(vMode) {

        if(vMode == 'MODIFY') {
            $('#btnProductEdit').addClass("blind");
            $('#btnProductSave').removeClass("blind");

            fn_enableForm("Y");
        }
        else if(vMode == 'VIEW') {
            $('#btnProductEdit').removeClass("blind");
            $('#btnProductSave').addClass("blind");

            fn_enableForm("N");
        }
    }

    function fn_enableForm(flag){

    	if(flag == 'Y'){
    	    $('#modifyForm').find(':input').prop("disabled", false);
    	    AUIGrid.setProp(stckGridID, "editable" , true);
    	}else if(flag == 'M'){
    		$('#modifyForm').find(':input').prop("disabled", true);
            AUIGrid.setProp(stckGridID, "editable" , false);
            $("input[name=modify_ctrl]").attr( 'disabled', false);
    	}else{
    		$('#modifyForm').find(':input').prop("disabled", true);
            AUIGrid.setProp(stckGridID, "editable" , false);
    	}

    	$("#quota_ekeyin_stus").multipleSelect("enable");
    	$("#quota_admin_stus").multipleSelect("enable");
        $("input[id=modify_stkId]").attr( 'disabled', false);

    }

    function fn_loadProductData(){
    	$("#modify_stkId").val('${productCtrlData.stkId}');

    	$("#modify_productCode").val('${productCtrlData.stkDesc}');

    	if('${productCtrlData.control}' == 'Yes'){
    		$('#modify_ctrlY').prop("checked", true);
    	}else{
    		$('#modify_ctrlN').prop("checked", true);
    	}

    	if('${productCtrlData.discontinued}' > 0){
    		$("#modify_discontinue").prop("checked", true).val(1);
    	}

    	$("#modify_startDt").val('${productCtrlData.startDate}');
    	$("#modify_startTm").val('${productCtrlData.startTime}');
    	$("#modify_endDt").val('${productCtrlData.endDate}');
    	$("#modify_endTm").val('${productCtrlData.endTime}');

    }

    function fn_getAdminKeyinQuota(){
    	Common.ajaxSync("GET", "/sales/productMgmt/selectAdminKeyinCount.do", $("#quotaForm").serialize(), function(result) {
    		if(result != null)
    			$("#quota_adminKeyin").val(result.count);
        });
    }

    function fn_getEKeyinQuota(){
    	Common.ajaxSync("GET", "/sales/productMgmt/selecteKeyinCount.do", $("#quotaForm").serialize(), function(result) {
    		if(result != null)
    		    $("#quota_ekeyin").val(result.count);
    	});
    }


</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code='sales.title.productMaintenance'/> – <spring:message code='sales.title.promo.view'/></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnClosePop" href="#"><spring:message code='sys.btn.close'/></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns">
    <li><p class="btn_blue"><a id="btnProductEdit" href="#"><spring:message code='sys.btn.edit'/></a></p></li>
    <li><p class="btn_blue"><a id="btnProductSave" href="#" class="blind"><spring:message code='sys.btn.save'/></a></p></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code='sal.page.subTitle.productInfo'/></h2>
</aside><!-- title_line end -->
<form id="modifyForm" name="modifyForm">
<input type="hidden" id="modify_stkId" name ="modify_stkId"/>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='sales.prod'/></th>
    <td><input id="modify_productCode" name="modify_productCode" type="text" class="w100p" readonly/></td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.title.stkCtrl'/></th>
    <td>
        <input id="modify_ctrlY" name="modify_ctrl" type="radio" value="1" onclick="fn_enableForm('Y')" /><span>Yes</span>
        <input id="modify_ctrlN" name="modify_ctrl" type="radio" value="0" onclick="fn_enableForm('M')"/><span>No</span>
    </td>
    <th scope="row"><spring:message code='sal.title.DISCONTINUE'/></th>
    <td>
    <input id="modify_discontinue" name="modify_discontinue" type="checkbox" >
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.StartDate'/></th>
    <td><input id="modify_startDt" name="modify_startDt" type="text" placeholder="DD/MM/YYYY" class="j_date w100p" readonly/></td>
    <th scope="row"><spring:message code='sales.StartTime'/></th>
    <td>
    <div class="w100p time_picker"><!-- time_picker start -->
    <input id="modify_startTm" name="modify_startTm" type="text" class="time_date" readonly/>
    <ul>
        <li>Time Picker</li>
        <li><a href="#">12:00 AM</a></li>
        <li><a href="#">01:00 AM</a></li>
        <li><a href="#">02:00 AM</a></li>
        <li><a href="#">03:00 AM</a></li>
        <li><a href="#">04:00 AM</a></li>
        <li><a href="#">05:00 AM</a></li>
        <li><a href="#">06:00 AM</a></li>
        <li><a href="#">07:00 AM</a></li>
        <li><a href="#">08:00 AM</a></li>
        <li><a href="#">09:00 AM</a></li>
        <li><a href="#">10:00 AM</a></li>
        <li><a href="#">11:00 AM</a></li>
        <li><a href="#">12:00 PM</a></li>
        <li><a href="#">01:00 PM</a></li>
        <li><a href="#">02:00 PM</a></li>
        <li><a href="#">03:00 PM</a></li>
        <li><a href="#">04:00 PM</a></li>
        <li><a href="#">05:00 PM</a></li>
        <li><a href="#">06:00 PM</a></li>
        <li><a href="#">07:00 PM</a></li>
        <li><a href="#">08:00 PM</a></li>
        <li><a href="#">09:00 PM</a></li>
        <li><a href="#">10:00 PM</a></li>
        <li><a href="#">11:00 PM</a></li>
    </ul>
    </div><!-- time_picker end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='sales.EndDate'/></th>
    <td><input id="modify_endDt" name="modify_endDt" type="text" placeholder="DD/MM/YYYY" class="j_date w100p" readonly/></td>
    <th scope="row"><spring:message code='sales.EndTime'/></th>
    <td>
    <div class="w100p time_picker"><!-- time_picker start -->
    <input id="modify_endTm" name="modify_endTm" type="text" class="time_date" readonly/>
    <ul>
        <li>Time Picker</li>
        <li><a href="#">12:00 AM</a></li>
        <li><a href="#">01:00 AM</a></li>
        <li><a href="#">02:00 AM</a></li>
        <li><a href="#">03:00 AM</a></li>
        <li><a href="#">04:00 AM</a></li>
        <li><a href="#">05:00 AM</a></li>
        <li><a href="#">06:00 AM</a></li>
        <li><a href="#">07:00 AM</a></li>
        <li><a href="#">08:00 AM</a></li>
        <li><a href="#">09:00 AM</a></li>
        <li><a href="#">10:00 AM</a></li>
        <li><a href="#">11:00 AM</a></li>
        <li><a href="#">12:00 PM</a></li>
        <li><a href="#">01:00 PM</a></li>
        <li><a href="#">02:00 PM</a></li>
        <li><a href="#">03:00 PM</a></li>
        <li><a href="#">04:00 PM</a></li>
        <li><a href="#">05:00 PM</a></li>
        <li><a href="#">06:00 PM</a></li>
        <li><a href="#">07:00 PM</a></li>
        <li><a href="#">08:00 PM</a></li>
        <li><a href="#">09:00 PM</a></li>
        <li><a href="#">10:00 PM</a></li>
        <li><a href="#">11:00 PM</a></li>
    </ul>
    </div><!-- time_picker end -->
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code='sales.title.quotaCountBy'/></h2>
</aside><!-- title_line end -->
<form id="quotaForm" name="quotaForm">
<input type="hidden" id="quota_stkId" name ="quota_stkId" value="${productCtrlData.stkId}"/>
<input type="hidden" id="quota_startDt" name ="quota_startDt" value="${productCtrlData.startDate}"/>
<input type="hidden" id="quota_startTm" name ="quota_startTm" value="${productCtrlData.startTime}"/>
<input type="hidden" id="quota_endDt" name ="quota_endDt" value="${productCtrlData.endDate}"/>
<input type="hidden" id="quota_endTm" name ="quota_endTm" value="${productCtrlData.endTime}"/>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">eKey-in</th>
    <td><input id="quota_ekeyin" name="quota_ekeyin" type="text" readonly/></td>
    <th scope="row">Order Management</th>
    <td><input id="quota_adminKeyin" name="quota_adminKeyin" type="text" readonly/></td>
</tr>
<tr>
    <th scope="row">eKey-in Status</th>
    <td>
        <select id="quota_ekeyin_stus" name="quota_ekeyin_stus" class="multy_select w50p" multiple="multiple">
            <option value="1">Active</option>
            <option value="104">Processing</option>
            <option value="4">Completed</option>
            <option value="21">Failed</option>
            <option value="10">Cancelled</option>
        </select>
        <a id="btnCountEkeyinQuota" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    </td>
    <th scope="row">Order Management Status</th>
    <td>
        <select id="quota_admin_stus" name="quota_admin_stus" class="multy_select w50p" multiple="multiple">
            <option value="1">Active</option>
            <option value="4">Completed</option>
            <option value="10">Cancelled</option>
        </select>
        <a id="btnCountAdminQuota" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<aside class="title_line">
<h2><spring:message code='sales.title.promoList4'/></h2>
</aside>

<ul class="right_btns">
    <li id="liProductDel" class="blind"><p class="btn_grid"><a id="btnProductDel" href="#"><spring:message code='sys.btn.del'/></a></p></li>
    <li id="liProductAdd" class="blind"><p class="btn_grid"><a id="btnProductAdd" href="#"><spring:message code='sys.btn.add'/></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="pop_stck_grid_wrap" style="width:100%; height:240px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

