<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
$(document).ready(function(){
     $('#cancelBtn').click(function() {
         $('#closeBtn').trigger("click");
     });

     $(".approveBtn").click(function(){
         var data = {
            selectMemEligibleId : $("#eligibleId").val(),
            selectApprStatusId : this.id
         }

         Common.ajax("POST", "/organization/submitMemberApproval.do", data,
             function(result) {

                 var str = "";
                 str += "<span>This rejoin member had <b>approved</b> by: <b>"+ result.data.userName +"</b></span><br/>";
                 str += "<span>Allowed to proceed New Member Tab register</span>";

                 Common.alert(str, fn_memberApprovalSearch);
                 $("#popup_wrap_memberApproval").remove();
             });
     });

     $(".rejectBtn").click(function(){
         var data = {
            selectMemEligibleId : $("#eligibleId").val(),
            selectApprStatusId : this.id
         }

         Common.ajax("POST", "/organization/submitMemberApproval.do", data,
             function(result) {

                 var str = "";
                 str += "<span>This rejoin member had <b>rejected</b> by: <b>"+ result.data.userName +"</b></span><br/>";
                 str += "<span>Not allowed to register as New Member</span>";

                 Common.alert(str, fn_memberApprovalSearch);
                 $("#popup_wrap_memberApproval").remove();
             });
     });
});
</script>

<!-- Pop up approve or reject member to rejoin -->
<div id="popup_wrap_memberApproval" class="popup_wrap msg_box"><!-- popup_wrap start -->
    <header class="pop_header"><!--     pop_header start -->
    <h1>Approval Member Rejoin</h1>
    <ul class="right_opt">
        <li><p class="btn_blue2"><a href="#" id="closeBtn">CLOSE</a></p></li>
    </ul>
    </header><!--     pop_header end -->

    <section class="pop_body"><!--     pop_body start -->
        <div style='text-align:center;'>
            <input type="hidden" id="eligibleId" name="eligibleId" value="${eligibleId}"/>
            <p style='color:#003eff;font-size:28px;padding:15px;'>ALERT!</p>

			<c:choose>
			    <c:when test="${selectApprStatusId=='5'}">
			         <p>Are you sure to approve this member to rejoin?</p>
			    </c:when>
			    <c:otherwise>
			        <p>Are you sure to reject this member to rejoin?</p>
			    </c:otherwise>
			</c:choose>
        </div>
        <ul class="center_btns">
            <c:choose>
                <c:when test="${selectApprStatusId=='5'}">
                    <li><p class="btn_blue2"><a href="#" id="5" class="approveBtn">Approve</a></p></li>
                </c:when>
                <c:otherwise>
                    <li><p class="btn_blue2"><a href="#" id="6" class="rejectBtn">Reject</a></p></li>
                </c:otherwise>
            </c:choose>
           <li><p class="btn_blue2"><a href="#" id="cancelBtn">Cancel</a></p></li>
        </ul>
    </section><!-- pop_body end -->
</div><!-- popup_wrap end -->