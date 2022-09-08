<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/moment.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.ui.datepicker.min.js"></script>
<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
</style>
<script  type="text/javascript">
$(document).ready(function () {
    console.log("crcAllowanceMasterPlanAddPop.jsp");

    $('#maxEndDateCheckButton').click(function() {
    	  if ($(this).is(':checked')) {
			$('#endDate').val('01/9999');
			$('#endDate').prop('disabled',true);
    	  }
    	  else{
			$('#endDate').val('');
			$('#endDate').prop('disabled',false);
    	  }
    	});
});

function submit(){
	if($('#startDate').val() == "" || $('#endDate').val() == "" || $('#planLimitAmt').val() == "" || $('#planLimitAmt').val() <= 0)
	{
        Common.alert("Please fill in all required fields");
		return false;
	}
	var todayDate = new Date();
	var currentMonth = new Date(todayDate.getFullYear(), todayDate.getMonth(), 1);
	var startDate = new Date(moment(moment($('#startDate').val(),'MM/YYYY')).format('MM/DD/YYYY'));
	var endDate = new Date(moment(moment($('#endDate').val(),'MM/YYYY')).format('MM/DD/YYYY'));

	if(startDate.getTime() < currentMonth.getTime()){
        Common.alert("No Past Months are allowed");
		return false;
	}
	if(startDate.getTime() > endDate.getTime()){
        Common.alert("End Month must be later than Start Month");
		return false;
	}
	Common.ajax("POST", "/eAccounting/creditCardAllowancePlan/createAllowanceDetailLimitPlan.do", $("#allowanceLimitForm").serializeJSON(), function(result) {
        console.log(result);
        if(result.code == "00"){
            $("#crcAllowanceMasterPlanAddPop").remove();
            fn_getAllowancePlanLimitDetailList();
        }
        else{
            Common.alert("Error: " + result.message);
            return;
        }
    });
}
</script>

<div id="popup_wrap" class="popup_wrap size_big1">
    <header class="pop_header">
        <h1>Allowance Plan Limit Add</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code="expense.CLOSE" /></a></p></li>
        </ul>
    </header>

    <section class="pop_body">
		<section class="search_table">
            <form action="#" method="post" id="allowanceLimitForm" name=""allowanceLimitForm"">
        		<input type="hidden" id="creditCardSeq" name="creditCardSeq" value="${cardHolder.crditCardSeq}">
                <section class="search_table">
                <table class="type1">
                        <caption>table</caption>
                        <colgroup>
                            <col style="width:150px" />
                            <col style="width:*" />
                            <col style="width:150px" />
                            <col style="width:*" />
                        </colgroup>

                        <tbody>
                            <tr>
                                <th scope="row">Card Holder Name</th>
                                <td>${cardHolder.crditCardUserName}</td>
                                <th scope="row">Card Holder Credit Card No</th>
                                <td>${cardHolder.crditCardNo}</td>
                            </tr>
                            <tr>
                                <th scope="row">Person In Charge Name</th>
                                <td>${cardHolder.picName}</td>
                                <th scope="row"></th>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                </section>

                <section class="search_table">
                    <table class="type1">
                        <caption>table</caption>
                        <colgroup>
                            <col style="width:150px" />
                            <col style="width:*" />
                            <col style="width:150px" />
                            <col style="width:*" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Start Month<span style="color:red;">*</span></th>
                                <td>
									<div class="date_set w100p">
	                                	<input type="text" title="Start Date"
												placeholder="MM/YYYY" class="j_date2" id="startDate" name="startDate" readonly/>
									</div>
                                </td>
                                <th scope="row">End Month<span style="color:red;">*</span></th>
                                <td>
                                	<div style="display:inline">
										<div class="date_set w100p" style="display:inline">
		                                	<input type="text" title="End Date"
													placeholder="MM/YYYY" class="j_date2" id="endDate" name="endDate" readonly/>
										</div>
										<div style="display:none;">
											<span>
												 Max End Date <input type="checkbox" id="maxEndDateCheckButton"/>
											</span>
										</div>
                                	</div>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Plan Limit Amount<span style="color:red;">*</span></th>
                                <td>
                                	<input id="planLimitAmt" name="planLimitAmt" type="number" title="Plan Limit Amount" step=".01" value="0" min="0"/>
                                </td>
                                <th scope="row"></th>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                </section>

                <section class="search_table">
                    <table class="type1">
                        <caption>table</caption>
                        <colgroup>
                            <col style="width:130px" />
                            <col style="width:*" />
                        </colgroup>
                        <tbody>
                            <tr>
                                <th scope="row">Remarks</th>
                                <td>
                                	<textArea id="remarks" name="remarks" cols="20" rows="5"></textArea>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                  </section>
                  <ul class="center_btns" id="reqBtns">
                    <li><p class="btn_blue"><a href="#" onclick="javascript:submit()">Submit</a></p></li>
                </ul>
            </form>
		</section>
    </section>
</div>