<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">

console.log("newVendorRegistMsgPop");
$(document).ready(function () {
    $("#no").click(fn_closePop);
    $("#yes").click(fn_approveLineSubmit);

});

function fn_closePop() {
	$("#registMsgPop").remove();
}

function fn_approveLineSubmit() {
	$("#registMsgPop").remove();

    var newGridList = AUIGrid.getOrgGridData(newGridID);
    var date = new Date();
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    var costCentr = $("#newCostCenter").val();
    console.log("CostCenter: " + costCentr);
    var data = {
            newGridList : newGridList
            ,year : year
            ,month : month
            ,costCentr : costCentr
    };
    console.log(data);

    // 예산확인
//    Common.ajax("POST", "/eAccounting/vendor/budgetCheck.do", data, function(result) {
//        console.log(result);
//        if(result.length > 0) {
//            Common.alert('There is no budget plan or the amount has exceeded.');
//            console.log(result.length);
//            for(var i = 0; i < result.length; i++) {
//                console.log(result[i]);
//                var rowIndex = AUIGrid.rowIdToIndex(newGridID, result[i])
//                 AUIGrid.setCellValue(newGridID, rowIndex, "yN", "N");
//                $("#registMsgPop").remove();
//                $("#approveLineSearchPop").remove();
//            }
//        } else {
        	var apprGridList = AUIGrid.getOrgGridData(approveLineGridID);
            var obj = $("#form_newVendor").serializeJSON();
            console.log("VendorRegistMsgPopObj: " + obj);
            obj.newGridList = newGridList;
            obj.apprGridList = apprGridList;

            Common.ajax("POST", "/eAccounting/vendor/checkFinAppr.do", obj, function(resultFinAppr) {
                console.log(resultFinAppr);

                if(resultFinAppr.code == "99") {
                    Common.alert("Please select the relevant final approver.");
                } else {
                    Common.ajax("POST", "/eAccounting/vendor/approveLineSubmit.do", obj, function(result) {
                        console.log(result);
                        Common.popupDiv("/eAccounting/vendor/newCompletedMsgPop.do", {callType:callType, clmNo:result.data.clmNo}, null, true, "completedMsgPop");
                        //Common.alert("Your authorization request was successful.");
                    });
                }
            });
        //}
//    });
}

</script>

<div id="popup_wrap" class="popup_wrap msg_box"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>New Vendor Registration</h1>
<p class="pop_close"><a href="#">CLOSE</a></p>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<p class="msg_txt">Are you sure you want to create this new Vendor into system?</p>
<ul class="center_btns">
	<li><p class="btn_blue2"><a href="#" id="yes">Yes</a></p></li>
	<li><p class="btn_blue2"><a href="#" id="no">No</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->