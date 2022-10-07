<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

$(document).ready(function() {
    $("#_generateBtn").click(function() {
        if(FormUtil.checkReqValue($('#memName')) &&
       		FormUtil.checkReqValue($('#memCode')) &&
            FormUtil.checkReqValue($('#orgToJoin option:selected')) &&
            FormUtil.checkReqValue($('#approvalStatus option:selected')) &&
            ($("#dpCreateDateFrom").val() == null || $("#dpCreateDateFrom").val().length == 0) &&
            ($("#dpCreateDateTo").val() == null || $("#dpCreateDateTo").val().length == 0)){
            Common.alert("* Please Key in at least one of the Member Name, Member Code, Sales Org to Join, Approval Status, Request Date From or Request Date To");
        }else{
        	btnGenerateEXCEL_Click();
        }
    });
});

$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (tag === 'select'){
            this.selectedIndex = 0;
        }

        $("#dpCreateDateFrom").empty();
        $("#dpCreateDateTo").empty();
    });
};

function btnGenerateEXCEL_Click(){
	  $("#reportFileName").val("");
      $("#reportDownFileName").val("");
      $("#viewType").val("");

      var memName  = $("#memName").val();
      var memCode = $("#memCode").val();
      var orgToJoin = $('#orgToJoin option:selected').val();
      var apprStatus = $('#approvalStatus option:selected').val();
      var createDateFrom =$("#dpCreateDateFrom").val();
      var createDateTo = $("#dpCreateDateTo").val();
      var whereSQL = "";

	  if(!(memName == null || memName == '')){
		  whereSQL += " AND UPPER(A.NAME) LIKE UPPER('%" + memName+"%')";
	  }

	  if(!(memCode == null || memCode == '')){
		  whereSQL += " AND A.MEM_CODE LIKE'"+ memCode.trim() +"%' ";
      }

	  if(!(orgToJoin == null || orgToJoin == '')){
          whereSQL += " AND A.SAL_ORG_REJOIN = " + orgToJoin;
      }

      if(apprStatus > 0){
          whereSQL += " AND A.APPR_STUS = "+ apprStatus;
      }

      if(!(createDateFrom == null || createDateFrom.length == 0)){
          whereSQL += " AND TO_DATE(A.CRT_DT) >= TO_DATE('"+createDateFrom+"', 'dd/MM/YYYY')";
      }

      if(!(createDateTo == null || createDateTo.length == 0)){
          whereSQL += " AND TO_DATE(A.CRT_DT) <= TO_DATE('"+createDateTo+"', 'dd/MM/YYYY')";
      }
      $("#form #V_WHERESQL").val(whereSQL);

      var date = new Date();
      var monthDay = date.getMonth()+1;
      var day = date.getDate();
      if(date.getDate() < 10){
          day = "0"+date.getDate();
      }
      if(monthDay < 10){
          monthDay = "0"+monthDay;
      }

      $("#form #viewType").val("EXCEL");
      $("#form #reportFileName").val("/organization/RejoinRawData_Excel.rpt");
      $("#form #reportDownFileName").val("RejoinRawData_"+day+monthDay+date.getFullYear());

       // 프로시져로 구성된 경우 꼭 아래 option을 넘겨야 함.
       var option = {
               isProcedure : false // procedure 로 구성된 리포트 인경우 필수.  => /payment/PaymentListing_Excel.rpt 는 프로시져로 구성된 파일임.
       };

       Common.report("form", option);
}


</script>

<div id="popup_wrap" class="popup_wrap size_small"><!-- popup_wrap start -->
	<header class="pop_header"><!-- pop_header start -->
        <h1>Rejoin Raw Listing</h1>
		<ul class="right_opt">
		    <li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
		</ul>
	</header><!-- pop_header end -->

	<section class="pop_body"><!-- pop_body start -->
		<aside class="title_line"><!-- title_line start -->
		</aside><!-- title_line end -->

		<section class="search_table"><!-- search_table start -->
			<form action="#" method="post" id="form">
				<input type="hidden" id="reportFileName" name="reportFileName" value="" />
				<input type="hidden" id="viewType" name="viewType" value="" />
				<input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
				<input type="hidden" id="V_WHERESQL" name="V_WHERESQL" value="" />

				<table class="type1"><!-- table start -->
					<caption>table</caption>
					<colgroup>
					    <col style="width:100px" />
					    <col style="width:*" />
					</colgroup>

					<tbody>
					    <tr>
                            <th scope="row">Member Name</th>
	                        <td>
	                           <input type="text" title="Name" placeholder="" class="w100p" id="memName" name="memName" />
	                        </td>
                        </tr>
					    <tr>
					        <th scope="row">Member Code</th>
	                        <td>
	                            <input type="text" title="Code" placeholder="" class="w100p" id="memCode" name="memCode" />
	                        </td>
                        </tr>
						<tr>
						    <th scope="row">Sales Org to Join</th>
						    <td>
							    <select class="w100p" id="orgToJoin" name="orgToJoin">
	                                <option value="" selected>Choose One</option>
	                                <option value="1">HP</option>
	                                <option value="2">CD</option>
	                                <option value="7">HT</option>
	                                <option value="3">CT</option>
                                </select>
						    </td>
						</tr>
						<tr>
						    <th scope="row">Approval Status</th>
	                        <td>
	                            <select class="w100p" id="approvalStatus" name="approvalStatus">
	                                <option value="" selected>Choose One</option>
	                                <option value="5">Approved</option>
	                                <option value="6">Rejected</option>
	                                <option value="44">Pending</option>
	                            </select>
	                        </td>
						</tr>
						<tr>
						    <th scope="row">Request Date</th>
						    <td>
							    <div class="date_set w100p"><!-- date_set start -->
							       <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" readonly id="dpCreateDateFrom" name="dpCreateDateFrom"/></p>
							       <span><spring:message code="sal.title.to" /></span>
							       <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" readonly id="dpCreateDateTo" name="dpCreateDateTo"/></p>
							    </div><!-- date_set end -->
						    </td>
						</tr>
					</tbody>
				</table><!-- table end -->

				<ul class="center_btns">
                    <li><p class="btn_blue2"><a href="#" id="_generateBtn">Generate</a></p></li>
				    <li><p class="btn_blue2"><a href="#" onclick="javascript:$('#form').clearForm();"><spring:message code="sal.btn.clear" /></a></p></li>
				</ul>
			</form>
		</section><!-- content end -->
	</section><!-- container end -->
</div><!-- popup_wrap end -->