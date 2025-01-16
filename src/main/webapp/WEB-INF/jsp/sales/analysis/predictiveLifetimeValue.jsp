<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">

var susListData = [
     {"codeId": "RAW","codeName": "Raw"}
    ,{"codeId": "AGING","codeName": "Aging"}
    ,{"codeId": "SUS_COUNT","codeName": "SUS : SUS Count"}
    ,{"codeId": "LAST_SUS","codeName": "SUS : Last SUS"}
    ,{"codeId": "SUS_SUM_YM","codeName": "SUS : Sum of Last SUS by Year and Month"}
];
var retTerListData = [
     {"codeId": "RAW","codeName": "Raw"}
    ,{"codeId": "AGING","codeName": "Aging"}
    ,{"codeId": "LAST_TER","codeName": "TER : Last TER"}
    ,{"codeId": "TER_SUM_YM","codeName": "TER : Sum of Last TER by Year and Month"}
    ,{"codeId": "LAST_RET_TER","codeName": "RET to TER : Last RET to TER"}
    ,{"codeId": "RET_TER_SUM_YM","codeName": "RET to TER : Sum of Last RET to TER by Year and Month"}
];

function fn_report() {
    if($("#listProductCat").val() == null || $("#listProductCat").val() == ''){
        Common.alert('Please select a product category.');
        return;
     }

    if($("#listProductCat").val() != null && $("#listProductCat").val() == '9999'){
        if($("#listProductId").val() == null || $("#listProductId").val() == ''){
            Common.alert('<spring:message code="sal.alert.msg.plzSelPrd" />' + ' as this option requires product selection');
            return;
         }
     }

    if($("#listRentStus").val() == null || $("#listRentStus").val() == ''){
        Common.alert('<spring:message code="sal.alert.msg.plzSelRentalStus" />');
        return;
     }

    if($("#listPltvReportType").val() == null || $("#listPltvReportType").val() == ''){
        Common.alert('<spring:message code="sal.alert.msg.plzSelReportType" />');
        return;
     }

    var reportType = $("#listPltvReportType").val();
    var stkId = $("#listProductId").val();
    var stkDesc = $("#listProductId option:selected").text();
    var rentStus = $("#listRentStus").val();
    var prodCatDesc = $("#listProductCat option:selected").text();

    if(stkId == null || stkId == ""){
    	stkId=0;
    	stkDesc = "All";
    }

    if (reportType == 'RAW') {

      $("#dataForm #reportFileName").val("/sales/PLTV_Raw.rpt");
      $("#dataForm #reportDownFileName").val(prodCatDesc + "_PLTV_Raw_" + "${maxAccYm}" + "_" + rentStus + "_" + stkDesc);
      $("#dataForm #V_RENTSTUS").val(rentStus);

    } else if (reportType == 'AGING') {

        $("#dataForm #reportFileName").val("/sales/PLTV_Aging.rpt");
        $("#dataForm #reportDownFileName").val(prodCatDesc + "_PLTV_Aging_" + "${maxAccYm}" + "_" + rentStus + "_" + stkDesc);
        $("#dataForm #V_RENTSTUS").val(rentStus);
        $("#dataForm #V_WHERESQL2").val(fn_whereSQL2());

    } else if (rentStus == 'SUS' && reportType == 'SUS_COUNT') {

        $("#dataForm #reportFileName").val("/sales/PLTV_SUS_Count.rpt");
        $("#dataForm #reportDownFileName").val(prodCatDesc + "_PLTV_SUS_Count_" + "${maxAccYm}" + "_" + rentStus + "_" + stkDesc);

    } else if (rentStus == 'SUS' && reportType == 'LAST_SUS') {

        $("#dataForm #reportFileName").val("/sales/PLTV_Last_SUS.rpt");
        $("#dataForm #reportDownFileName").val(prodCatDesc + "_PLTV_Last_SUS_" + "${maxAccYm}" + "_" + rentStus + "_" + stkDesc);

    } else if (rentStus == 'SUS' && reportType == 'SUS_SUM_YM') {

        $("#dataForm #reportFileName").val("/sales/PLTV_SUS_SumYM.rpt");
        $("#dataForm #reportDownFileName").val(prodCatDesc + "_PLTV_SUS_SumYM_" + "${maxAccYm}" + "_" + rentStus + "_" + stkDesc);

    } else if (rentStus == 'RET_TER' && reportType == 'LAST_TER') {

        $("#dataForm #reportFileName").val("/sales/PLTV_Last_TER.rpt");
        $("#dataForm #reportDownFileName").val(prodCatDesc + "_PLTV_Last_TER_" + "${maxAccYm}" + "_" + rentStus + "_" + stkDesc);

    } else if (rentStus == 'RET_TER' && reportType == 'TER_SUM_YM') {

        $("#dataForm #reportFileName").val("/sales/PLTV_TER_SumYM.rpt");
        $("#dataForm #reportDownFileName").val(prodCatDesc + "_PLTV_TER_SumYM_" + "${maxAccYm}" + "_" + rentStus + "_" + stkDesc);

    } else if (rentStus == 'RET_TER' && reportType == 'LAST_RET_TER') {

        $("#dataForm #reportFileName").val("/sales/PLTV_Last_RET_TER.rpt");
        $("#dataForm #reportDownFileName").val(prodCatDesc + "_PLTV_Last_RET_TER_" + "${maxAccYm}" + "_" + rentStus + "_" + stkDesc);
        $("#dataForm #V_WHERESQL2").val(fn_whereSQL2());

    } else if (rentStus == 'RET_TER' && reportType == 'RET_TER_SUM_YM') {

        $("#dataForm #reportFileName").val("/sales/PLTV_RET_TER_SumYM.rpt");
        $("#dataForm #reportDownFileName").val(prodCatDesc + "_PLTV_RET_TER_SumYM_" + "${maxAccYm}" + "_" + rentStus + "_" + stkDesc);
        $("#dataForm #V_WHERESQL2").val(fn_whereSQL2());

    }

    $("#dataForm #V_STKID").val(stkId);
    $("#dataForm #viewType").val("EXCEL");
    $("#dataForm #V_WHERESQL").val(fn_whereSQL());


    var option = {
        isProcedure : true
    };

    Common.report("dataForm", option);
}

function fn_whereSQL() {

	let isExtrade = $("#dataForm #listExtrade option:selected").val();
	let listRentalType = $("#dataForm #listRentalType option:selected").val();
	let listMattressType = $("#dataForm #listMattressType option:selected").val();
	let listProductCat = $("#dataForm #listProductCat option:selected").val();

	let whereSQL = '';

	if( !FormUtil.isEmpty(isExtrade) ){
		whereSQL += ' AND A.EX_TRADE = ' + isExtrade;
	}

    if( !FormUtil.isEmpty(listRentalType) ){
    	whereSQL += " AND A.RENTAL_TYPE = '" + listRentalType + "'";
    }

    if( !FormUtil.isEmpty(listMattressType) ){
        whereSQL += " AND A.HC_PACK = '" + listMattressType + "'";
    }
//TEMP disable
//     if( !FormUtil.isEmpty(listProductCat) ){
//         whereSQL += " AND A.ACC_DEBT_OPNG_STOCK_CAT_ID = '" + listProductCat + "'";
//     }

	return whereSQL;
}

function fn_whereSQL2() {

	let listProductCat = $("#dataForm #listProductCat option:selected").val();

	let whereSQL2 = '';

//TEMP disable
//     IF( !FORMUTIL.ISEMPTY(LISTPRODUCTCAT) ){
//     	WHERESQL2 += " AND ACC_DEBT_OPNG_STOCK_CAT_ID = '" + LISTPRODUCTCAT + "'";
//     }

	return whereSQL2;
}

$(function(){
	doGetComboOrder('/sales/analysis/selectPltvProductCategoryList.do', '', 'CODE_ID', '66', 'listProductCat',  'S');

	doGetComboAndGroup2('/sales/analysis/selectPltvProductCodeList.do', '' , '', 'listProductId', 'S', 'fn_setOptGrpClass');

	$('#listProductCat').change(function() {

		$('#listProductId').empty();
		doGetComboAndGroup2('/sales/analysis/selectPltvProductCodeList.do', {stkCtgryId:this.value} , '', 'listProductId', 'S', 'fn_setOptGrpClass');
		(this.value == 9999 || this.value == 5706) ? $('#mattressPackRow').show() : $('#mattressPackRow').hide();

	});

	$('#listRentStus').change(function() {
	    switch(this.value){
	    case "SUS" :
	        doDefCombo(susListData, '' ,'listPltvReportType', 'S', '');
	        break;
	    case "RET_TER" :
	        doDefCombo(retTerListData, '' ,'listPltvReportType', 'S', '');
	        break;
	    default :
	        doDefCombo('', '' ,'listPltvReportType', 'S', '');
	        break;
           }
	    });
});

function fn_setOptGrpClass() {
    $("optgroup").attr("class" , "optgroup_text");
}

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="sal.title.pltv" /></h2>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="dataForm" method="post">
    <input type="hidden" id="reportFileName" name="reportFileName" />
    <input type="hidden" id="viewType" name="viewType" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName"  />
    <input type="hidden" id="V_STKID" name="V_STKID" />
    <input type="hidden" id="V_RENTSTUS" name="V_RENTSTUS" />
    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL" />
    <input type="hidden" id="V_WHERESQL2" name="V_WHERESQL2" />
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sales.ProductCategory" /></th>
    <td>
        <select class="w100p" id="listProductCat" name="listProductCat" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.prod" /></th>
    <td>
        <select class="w100p" id="listProductId" name="listProductId" />
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.RentalStatus" /></th>
    <td>
        <select class="w100p" id="listRentStus" name="listRentStus" >
            <option value="">Choose One</option>
            <option value="SUS">SUS</option>
            <option value="RET_TER">RET, TER</option>
        </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.pltv.ReportType" /></th>
    <td>
        <select class="w100p" id="listPltvReportType" name="listPltvReportType" ></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.extrade" /></th>
    <td>
        <select class="w50p" id="listExtrade" name="listExtrade" >
            <option value="">Choose One</option>
            <option value="1">Yes</option>
            <option value="0">No</option>
        </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sales.rentalType" /></th>
    <td>
        <select class="w50p" id="listRentalType" name="listRentalType" >
            <option value="">Choose One</option>
            <option value="OL">OL</option>
            <option value="FL">FL</option>
        </select>
    </td>
</tr>
<tr id="mattressPackRow" style="display:none">
    <th scope="row">Mattress Package</th>
    <td>
        <select class="w50p" id="listMattressType" name="listMattressType" >
            <option value="">Choose One</option>
            <option value="2">Mattress Set</option>
            <option value="1">Mattress Only</option>
        </select>
    </td>
</tr>
<tr>
    <td colspan="2"><p><span><spring:message code="sal.title.text.latestRentMonthYear" />${maxAccYm}</span></p></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_report();"><spring:message code="sal.btn.genExcel" /></a></p></li>
</ul>

</section><!-- content end -->