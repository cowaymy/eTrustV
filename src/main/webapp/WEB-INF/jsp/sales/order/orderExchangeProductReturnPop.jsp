<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

var date = new Date().getDate();
if(date.toString().length == 1){
    date = "0" + date;
}

//doGetComboSepa("/common/selectBranchCodeList.do",2 , '-',''   , 'branch' , 'S', '');

/* 멀티셀렉트 플러그인 start */
$('.multy_select').change(function() {
   //console.log($(this).val());
})
.multipleSelect({
   width: '100%'
});

function btnGenerate_Click(val){

	var whereSQL = "";
	var runNo = 0;

	/* if(val = "PDF"){

		if($("#cmbStatus :selected").length > 0){
	        whereSQL += " AND (";

	        $('#cmbStatus :selected').each(function(i, mul){
	            if(runNo == 0){
	                whereSQL += " sre.STUS_CODE_ID = '"+$(mul).val()+"' ";
	            }else{
	                whereSQL += " OR sre.STUS_CODE_ID = '"+$(mul).val()+"' ";
	            }
	            runNo += 1;
	        });
	        whereSQL += ") ";
	        runNo = 0;
	    }

		if(!($("#txtOrdNoStart").val().trim() == null || $("#txtOrdNoStart").val().trim().length == 0)){
	        whereSQL += " AND som.SALES_ORD_NO >= '"+$("#txtOrdNoStart").val().trim().replace("'", "''")+"' ";
	    }

		if(!($("#txtOrdNoEnd").val().trim() == null || $("#txtOrdNoEnd").val().trim().length == 0)){
            whereSQL += " AND som.SALES_ORD_NO < '"+$("#txtOrdNoEnd").val().trim().replace("'", "''")+"' ";
        }

		if(!($("#txtInsNoStart").val().trim() == null || $("#txtInsNoStart").val().trim().length == 0)){
            whereSQL += " AND ie.INSTALL_ENTRY_NO >= '"+$("#txtInsNoStart").val().trim().replace("'", "''")+"' ";
        }

        if(!($("#txtInsNoEnd").val().trim() == null || $("#txtInsNoEnd").val().trim().length == 0)){
            whereSQL += " AND ie.INSTALL_ENTRY_NO < '"+$("#txtInsNoEnd").val().trim().replace("'", "''")+"' ";
        }

        if(!($("#txtCtCdStart").val().trim() == null || $("#txtCtCdStart").val().trim().length == 0)){
            whereSQL += " AND m.MEM_CODE >= '"+$("#txtCtCdStart").val().trim().replace("'", "''")+"' ";
        }

        if(!($("#txtCtCdEnd").val().trim() == null || $("#txtCtCdEnd").val().trim().length == 0)){
            whereSQL += " AND m.MEM_CODE < '"+$("#txtCtCdEnd").val().trim().replace("'", "''")+"' ";
        }

        if(!($("#branch").val().trim() == null || $("#branch").val().trim().length == 0)){
            whereSQL += " AND b.BRNCH_ID = '"+$("#branch").val().trim().replace("'", "''")+"' ";
        }
	} */
	if(!($("#dpReqDateFrom").val() == null || $("#dpReqDateFrom").val().length == 0)){
        whereSQL += " AND soe.SO_EXCHG_CRT_DT >= TO_DATE('"+$("#dpReqDateFrom").val()+"', 'DD/MM/YYYY') ";
    }

	if(!($("#dpReqDateTo").val() == null || $("#dpReqDateTo").val().length == 0)){
        whereSQL += " AND soe.SO_EXCHG_CRT_DT < TO_DATE('"+$("#dpReqDateTo").val()+"', 'DD/MM/YYYY') ";
    }

	if(!($("#dpInsDateFrom").val() == null || $("#dpInsDateFrom").val().length == 0)){
	    whereSQL += " AND ir.INSTALL_DT >= TO_DATE('"+$("#dpInsDateFrom").val()+"', 'DD/MM/YYYY') ";
	}

    if(!($("#dpInsDateTo").val() == null || $("#dpInsDateTo").val().length == 0)){
        whereSQL += " AND ir.INSTALL_DT < TO_DATE('"+$("#dpInsDateTo").val()+"', 'DD/MM/YYYY') ";
    }



	$("#viewType").val("EXCEL");
    $("#V_WHERESQL").val(whereSQL);

    $("#reportDownFileName").val("ExchangeStockRetListing_Excel_"+date+(new Date().getMonth()+1)+new Date().getFullYear());
    $("#reportFileName").val("/sales/ExchangeStockRetListing_Excel.rpt");

    // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
    };

    Common.report("form", option);

}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.exchangeStkRet" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="form">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <%-- <th scope="row"><spring:message code="sal.title.text.returnStatus" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="cmbStatus" data-placeholder="Return Status">
        <option value="1"><spring:message code="sal.btn.active" /></option>
        <option value="4"><spring:message code="sal.combo.text.complete" /></option>
    </select>
    </td> --%>
    <th scope="row"><spring:message code="sal.title.text.requestDate" /><span class="brown_text">*</span></th>
    <td colspan='3'>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Request start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpReqDateFrom" value="${startDate}"/></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="Request end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpReqDateTo" value="${endDate}"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <%-- <th scope="row"><spring:message code="sal.text.insNo" /></th>
    <td>
        <div class="date_set w100p"><!-- date_set start -->
        <p><input type="text" title="" placeholder="" class="w100p" id="txtInsNoStart"/></p>
        <span><spring:message code="sal.title.to" /></span>
        <p><input type="text" title="" placeholder="" class="w100p"id="txtInsNoEnd"/></p>
        </div><!-- date_set end -->
    </td> --%>
     <th scope="row"><spring:message code="sal.text.insDate" /><span class="brown_text">*</span></th>
    <td colspan='3'>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Install start Date" placeholder="DD/MM/YYYY" class="j_date" id="dpInsDateFrom"/></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="Install end Date" placeholder="DD/MM/YYYY" class="j_date" id="dpInsDateTo"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<%-- <tr>
    <th scope="row"><spring:message code="sal.text.ordNo" /></th>
    <td>
        <div class="date_set w100p"><!-- date_set start -->
        <p><input type="text" title="" placeholder="" class="w100p" id="txtOrdNoStart"/></p>
        <span><spring:message code="sal.title.to" /></span>
        <p><input type="text" title="" placeholder="" class="w100p"id="txtOrdNoEnd"/></p>
        </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="sal.text.ctCd" /></th>
    <td>
        <div class="date_set w100p"><!-- date_set start -->
        <p><input type="text" title="" placeholder="" class="w100p" id="txtCtCdStart"/></p>
        <span><spring:message code="sal.title.to" /></span>
        <p><input type="text" title="" placeholder="" class="w100p"id="txtCtCdEnd"/></p>
        </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.dscBrnch" /></th>
    <td>
        <select class="w100p" id="branch" name="branch"></select>
    </td>
    <th scope="row" colspan='2'></th>
</tr> --%>
<tr>
    <th scope="row" colspan='4'>Generate Excel format is only search in (*) fields.</th>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
    <li><p class="btn_blue2"><a href="#" onclick="javascript: btnGenerate_Click('EXCEL')"><spring:message code="sal.btn.genExcel" /></a></p></li>
    <%-- <li><p class="btn_blue2"><a href="#" onclick="javascript: btnGenerate_Click('PDF')"><spring:message code="sal.btn.genPDF" /></a></p></li> --%>
</ul>

<input type="hidden" id="reportFileName" name="reportFileName" value="" />
<input type="hidden" id="viewType" name="viewType" value="EXCEL" />
<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />

<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="">

</form>

</section><!-- content end -->

</section><!-- container end -->

</div><!-- popup_wrap end -->