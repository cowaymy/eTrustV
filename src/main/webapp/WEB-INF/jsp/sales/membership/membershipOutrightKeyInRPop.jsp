<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
$(document).ready(function() {
    //brnch
    CommonCombo.make('_cmbBranch', '/sales/ccp/getBranchCodeList', '' , '', '' ,fn_multy);

     //Member Search Popup
    $('#memBtn').click(function() {
        Common.popupDiv("/common/memberPop.do", $("#searchForm").serializeJSON(), null, true);
    });

    /* $('#salesmanCd').change(function(event) {

        var memCd = $('#salesmanCd').val().trim();

        if(FormUtil.isNotEmpty(memCd)) {
            fn_loadOrderSalesman(0, memCd);
        }
    }); */

});

function fn_generate(method){


    //variable
    var runNo = 0;
    var whereSQL = '';
    var keyInMemNo = '';
    var keyInBranch = '';
    var keyInDate = '';
    var orderBySql = '';

    //VIEW
    if(method == "PDF"){
        $("#_viewType").val('PDF');//method
    }
    if(method == "EXCEL"){
        $("#_viewType").val('EXCEL');//method
    }

    //Param Setting
    //Where Sql
    if($("#_fromMemNo").val() != null && $("#_fromMemNo").val() != '' && $("#_toMemNo").val() != null && $("#_toMemNo").val() != ''){

        keyInMemNo = $("#_fromMemNo").val().trim() + " To " +  $("#_toMemNo").val().trim();
        whereSQL += " AND (sm.SRV_MEM_NO BETWEEN '" + $("#_fromMemNo").val().trim() + "' AND '" + $("#_toMemNo").val().trim() + "')'";
    }
    if($("#_frDate").val() != null && $("#_frDate").val() != '' && $("#_toDate").val() != null && $("#_toDate").val() != '' ){

        keyInDate = $("#_frDate").val().trim() + " To " +  $("#_toDate").val().trim();
        whereSQL += " AND (sm.SRV_CRT_DT BETWEEN  TO_DATE('"+$("#_frDate").val().trim()+"' , 'DD/MM/YYYY') AND TO_DATE('"+$("#_toDate").val().trim()+"' , 'DD/MM/YYYY') )";

    }

    var brnchArr = [];

    if($("#_cmbBranch :selected").length > 0){
        whereSQL += " AND (";
        $('#_cmbBranch :selected').each(function(i, e){

            if(runNo > 0){
            	brnchArr.push($(e).val());
                whereSQL += " OR sm.SRV_MEM_BRNCH_ID = " + $(e).val();
            }else{
            	brnchArr.push($(e).val());
                whereSQL += "  sm.SRV_MEM_BRNCH_ID = " + $(e).val();
            }
            runNo += 1;
        });
        whereSQL += ") ";

        //keyInBranch
        /*** get Branch Code*/
	    Common.ajax("GET", "/sales/membership/getBrnchCodeListByBrnchId", {brnchArr : brnchArr},function(result){
	    	if(result != null){
	    		  $(result).each(function(idx, el){

					if(idx > 0){
						keyInBranch += "," + el.code;
					}else{
						keyInBranch += el.code;
					}
				  });
	    	 }
	    },'',{async : false});

     }
     runNo = 0;

     if($("#hiddenSalesmanId").val() != null && $("#hiddenSalesmanId").val() != ''){
         WhereSQL += "AND sm.SRV_CRT_USER_ID = " + $("#hiddenSalesmanId").val() + " ";
     }

     if($("#dataForm #isHc").val() != null && $("#dataForm #isHc").val() != ''){
    	 whereSQL += " AND som.BNDL_ID IS NOT NULL ";
     }else{
    	 whereSQL += " AND som.BNDL_ID IS NULL ";
     }

     if($("#_sortBy").val() != null && $("#_sortBy").val() != '' ){

         if($("#_sortBy").val() == '1'){
             orderBySql = " ORDER BY som.SALES_ORD_NO ";
         }
         if($("#_sortBy").val() == '2'){
             orderBySql = " ORDER BY c.NAME ";
         }
         if($("#_sortBy").val() == '3'){
             orderBySql = " ORDER BY  sm.SRV_MEM_BRNCH_ID ";
         }
         if($("#_sortBy").val() == '4'){
            orderBySql = " ORDER BY  sm.SRV_MEM_ID";
         }
         if($("#_sortBy").val() == '5'){
             orderBySql = " ORDER BY u.USER_NAME ";
         }
     }

     //CURRENT DATE
     var date = new Date().getDate();
     if(date.toString().length == 1){
         date = "0" + date;
     }

    //FILE NAME

//        $("#reportFileName").val('/membership/MembershipKeyInList.rpt'); //File Name
        $("#reportDownFileName").val('MembershipKeyInList_'+date+(new Date().getMonth()+1)+new Date().getFullYear()); ////DOWNLOAD FILE NAME

        //params
        console.log("keyInBranch : " + keyInBranch);

        $("#V_KEYINMEMNO").val(keyInMemNo);
        $("#V_KEYINBRANCH").val(keyInBranch);
        $("#V_KEYINDATE").val(keyInDate);
        $("#V_SELECTSQL").val("");
        $("#V_WHERESQL").val(whereSQL);
        $("#V_ORDERBYSQL").val(orderBySql);
        $("#V_FULLSQL").val("");

    var option = {
            isProcedure : true // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
        };

        Common.report("dataForm", option);

}

function fn_loadOrderSalesman(memId, memCode, isPop) {

    Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {

        if(memInfo == null) {
            Common.alert('<b><spring:message code="sal.alert.msg.memNotFound" />'+memCode+'</b>');
        }
        else {
           // console.log("멤버정보");

                $('#hiddenSalesmanId').val(memInfo.memId);
                $('#salesmanCd').val(memInfo.name);
                $('#salesmanCd').removeClass("readonly");
        }
    });
}

function fn_multy(){
    /* 멀티셀렉트 플러그인 start */
 $('.multy_select').change(function() {
    //console.log($(this).val());
 })
 .multipleSelect({
    width: '100%'
 });
}
</script>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.keyInList" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->

</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->

<form id="dataForm" name="dataForm">
    <input type="hidden" id="reportFileName" name="reportFileName" value="/membership/MembershipKeyInList.rpt" />
    <input type="hidden" id="_viewType" name="viewType" />
    <!--param  -->
    <!-- 1 -->
    <input type="hidden" id="V_KEYINMEMNO" name="V_KEYINMEMNO"  />
    <input type="hidden" id="V_KEYINBRANCH" name="V_KEYINBRANCH"  />
    <input type="hidden" id="V_KEYINDATE" name="V_KEYINDATE"  />
    <input type="hidden" id="V_SELECTSQL" name="V_SELECTSQL"  />
    <input type="hidden" id="V_WHERESQL" name="V_WHERESQL"  />
    <input type="hidden" id="V_ORDERBYSQL" name="V_ORDERBYSQL"  />
    <input type="hidden" id="V_FULLSQL" name="V_FULLSQL"  />

    <!--common param  -->
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" />
    <input id="isHc" name="isHc" type="hidden" value='${isHc}'/>

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
    <th scope="row"><spring:message code="sal.text.membershipNo" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="" placeholder="" class="w100p" id="_fromMemNo"/></p>
    <span>To</span>
    <p><input type="text" title="" placeholder="" class="w100p" id="_toMemNo"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="sal.text.keyInDate" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" placeholder="DD/MM/YYYY" class="j_date" id="_frDate" readonly="readonly"/></p>
    <span><spring:message code="sal.text.to" /></span>
    <p><input type="text" placeholder="DD/MM/YYYY" class="j_date" id="_toDate" readonly="readonly"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.keyInBranch" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="_cmbBranch">
    </select>
    </td>
    <th scope="row"><spring:message code="sal.text.keyInUser" /></th>
    <td>
        <div class="search_100p"><!-- search_100p start -->
        <input id="salesmanCd" name="salesmanCd" type="text" title="" placeholder="" class="w100p" readonly="readonly"/>
        <input id="hiddenSalesmanId" name="salesmanId" type="hidden"  />
        <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.sortingBy" /></th>
    <td>
    <select class="w100p" id="_sortBy">
        <option value="1"><spring:message code="sal.text.ordNum" /></option>
        <option value="2"><spring:message code="sal.text.custName" /></option>
        <option value="3"><spring:message code="sal.text.keyInBranch" /></option>
        <option value="4"><spring:message code="sal.text.keyInDate" /></option>
        <option value="5"><spring:message code="sal.text.keyInUser" /></option>
    </select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->
<div style="height: 300px"></div>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_generate('PDF');"><spring:message code="sal.btn.genToPdf" /></a></p></li>
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_generate('EXCEL');"><spring:message code="sal.btn.genToExcel" /></a></p></li>
    <li><p class="btn_blue2 big"><a href="#"><spring:message code="sal.btn.clear" /></a></p></li>
</ul>

</form>
</section><!-- search_table end -->

</section><!-- content end -->
</div>
