<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/javaScript">

//AUIGrid 그리드 객체
var myGridID,enrollmentItemId;

//Grid에서 선택된 RowID
var selectedGridValue;

//Status Combo Data
var statusData = [{"codeId": "1","codeName": "Active"},{"codeId": "4","codeName": "Completed"},{"codeId": "8","codeName": "Inactive"},{"codeId": "21","codeName": "Failed"}];

var bankData = [{"codeId": "3","codeName": "CIMB Bank"}];

var gridPros = {
        // 편집 가능 여부 (기본값 : false)
        editable : false,

        // 상태 칼럼 사용
        showStateColumn : false
    };
// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
$(document).ready(function(){
    //메인 페이지
    //Grid Properties 설정

    // Order 정보 (Master Grid) 그리드 생성
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,null,gridPros);
    //updResultGridID = GridCommon.createAUIGrid("updResult_grid_wrap", updResultColLayout,null,gridPros);
    enrollmentItemId = GridCommon.createAUIGrid("#enrollmentItem_grid_wrap", columnLayout2,null,gridPros);
    AUIGrid.resize(enrollmentItemId,945, $(".grid_wrap").innerHeight());

    // Master Grid 셀 클릭시 이벤트
    AUIGrid.bind(myGridID, "cellClick", function( event ){
        selectedGridValue = event.rowIndex;
    });

});

// AUIGrid 칼럼 설정
var columnLayout = [
    { dataField:"enrollmentId" ,headerText:"Enrollment Id" ,editable : false },
    { dataField:"stusCode" ,headerText:"Status",editable : false },
    { dataField:"bankName" ,headerText:"Issue Bank",editable : false },
    { dataField:"debtDt" ,headerText:"Debit Date" ,editable : false},
    { dataField:"crtDt" ,headerText:"Create Date" ,editable : false },
    { dataField:"crtName" ,headerText:"Creator" ,editable : false },
    { dataField:"updDt" ,headerText:"Update Date" ,editable : false },
    { dataField:"updName" ,headerText:"Updator" ,editable : false },
    { dataField:"totRec" ,headerText:"Total Records", visible : false, editable : false },
    ];


var columnLayout2= [
    {dataField : "stusName", headerText : "Status"},
    {dataField : "salesOrderId", headerText : "Order No"},
    {dataField : "accName", headerText : "Customer Name"},
    {dataField : "accNric", headerText : "NRIC"},
    {dataField : "limitAmt", headerText : "Amount Limit"},
    {dataField : "billAmt", headerText : "Amount"},
    {dataField : "debtDt", headerText : "Enrollment Date"},
    {dataField : "crtName", headerText : "Creator"},
    {dataField : "crtDt", headerText : "Created"},
    ];

// 리스트 조회.
function fn_getEEnrollList(){
    Common.ajax("GET", "/payment/selectEnrollmentH2H", $("#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}
function fn_clear(){
    $("#searchForm")[0].reset();
}
//View Claim Pop-UP
function fn_openDivPop(val){
    if(val == "VIEW" || val == "FILE"){

        var selectedItem = AUIGrid.getSelectedIndex(myGridID);

        if (selectedItem[0] > -1){

            var enrollId = AUIGrid.getCellValue(myGridID, selectedGridValue, "enrollmentId");
            var stusName = AUIGrid.getCellValue(myGridID, selectedGridValue, "stusName");
            var stusCode = AUIGrid.getCellValue(myGridID, selectedGridValue, "stusCode");
            var bankCode = AUIGrid.getCellValue(myGridID, selectedGridValue, "bankCode");
            var bankName = AUIGrid.getCellValue(myGridID, selectedGridValue, "bankName");
            var totRec = AUIGrid.getCellValue(myGridID, selectedGridValue, "totRec");


            if((val == "RESULT") && fileBatchStusId != 1){
                Common.alert("<b>Batch [" + fileBatchId + "] is under status [" + stusName + "].<br />" +
                        "Only [Active] batch is allowed to update e-enrollment result.</b>");
            }else{
                Common.ajax("GET", "/payment/selectH2HEnrollmentById.do", {"enrollmentId":enrollId}, function(result) {
                    AUIGrid.setGridData(enrollmentItemId, result);
                });

                Common.ajax("GET", "/payment/selectH2HEnrollmentListById.do", {"enrollmentId":enrollId}, function(result) {
                    $("#view_wrap").show();
                    $("#new_wrap").hide();

                    $("#view_enrollmentId").text(result.enrlId);
                    $("#view_stusName").text(result.stusName);
                    $("#view_salesOrderId").text(result.salesOrderId);
                    $("#view_accName").text(result.accName);
                    $("#view_accNric").text(result.accNric);
                    $("#view_issueBank").text(bankCode + ' - ' + bankName);
                    $("#view_limitAmt").text(result.limitAmt);
                    $("#view_billAmt").text(result.billAmt);
                    $("#view_debtDt").text(result.debtDt);
                    $("#view_crtName").text(result.crtName);
                    $("#view_crtDt").text(result.crtDt);
                    $("#view_updName").text(result.updName);
                    $("#view_updDt").text(result.updDt);
                    $("#view_totRec").text(totRec);

                });
            }

            //팝업 헤더 TEXT 및 버튼 설정
            if(val == "VIEW"){
                $('#pop_header h1').text('VIEW E-ENROLLMENT');
                $('#pop_header h3').text('ALL TRANSACTION');
                $('#center_btns1').hide();
                $('#center_btns2').hide();
                $('#center_btns3').hide();
                $('#center_btns4').hide();


            }

            else if ((val == "FILE") && stusCode == "ACT"){
                $('#pop_header h1').text('E-ENROLLMENT FILE GENERATOR');
                $('#pop_header h3').text('ALL TRANSACTION');
                $('#center_btns1').show();
                $('#center_btns2').hide();
                $('#center_btns3').hide();
                $('#center_btns4').hide();

            }else{

            	Common.alert("Only [Active] e-Enrollment is allowed to deactivate. <br /> Batch ID :" + enrollId + "<br /> Status : " + stusCode);
            	$('#center_btns1').hide();
            }

        }else{
             Common.alert("No enrollment record selected.");
        }
    }else{
        $("#view_wrap").hide();
        $("#new_wrap").show();
        //NEW CLAIM 팝업에서 필수항목 표시 DEFAULT
        $("#newForm")[0].reset();
    }
}

//Layer close
hideViewPopup=function(val){
    $(val).hide();
}

function fn_clear(){
    $("#searchForm")[0].reset();
}

function fn_getItmStatus(val){
    var enrollId = AUIGrid.getCellValue(myGridID, selectedGridValue, "enrollmentId");
    //Common.alert(enrollId);
    if(val == "4"){$('#pop_header h3').text('COMPLETED ENROLLMENTS');}
    else if(val == "1"){$('#pop_header h3').text('ACTIVE ENROLLMENTS');}
    else{$('#pop_header h3').text('ALL RECORDS');}

    Common.ajax("GET", "/payment/selectH2HEnrollmentSubListById.do", {"enrollmentId":enrollId,"status":val}, function(result) {
        AUIGrid.setGridData(enrollmentItemId, result);
    });
}

function fn_genClaim(){
    if($("#new_issueBank option:selected").val() == ''){
        Common.alert("* Please select Issue Bank.<br />");
        return;
    }

    Common.ajax("GET", "/payment/generateNewEEnrollment.do", $(
    "#newForm").serialize(), function(result) {
                 var message = "";

              if(result.code == "FILE_OK"){
                     message += "New enrollment batch successfully generated.<br /><br />";
                     message += "Batch ID : " + result.data.enrollmentId + "<br />";
                     message += "Issuing Bank : " + result.data.bankName + "<br />";
                     message += "Total Accounts : " + result.data.totRec + "<br />";
                     message += "Creator : " + result.data.crtName + "<br />";
                     message += "Create Date : " + result.data.crtDt + "<br />";
                 }else{
                     message += "Failed to generate new eEnrollment Batch. Please try again later.";
                 }

                 Common.alert("<b>" + message + "</b>");
           },
           function(result) {
                 Common.alert("<b>Failed to generate new eEnrollment Batch. Please try again later.</b>");
           }
    );

}

function fn_createFile(){
	var selectedItem = AUIGrid.getSelectedIndex(myGridID);
    var enrollId = AUIGrid.getCellValue(myGridID, selectedGridValue, "enrollmentId");

    Common.ajax("GET", "/payment/createEEnrollment.do", {"enrollmentId":enrollId},function(result) {
                 Common.alert("<b>eEnrollment file has successfully created. <br /> Batch Id : " + enrollId + "</b>");

           },
           function(result) {
                 Common.alert("<b>Failed to generate eEnrollment file. Please try again later.</b>");
           }
    );
}

function fn_deactivate(){
	Common.confirm('<b>Are you sure want to deactivate this batch ?</b>',function (){
        var enrollId = AUIGrid.getCellValue(myGridID, selectedGridValue, "enrollmentId");

        Common.ajax("GET", "/payment/eEnrollmentDeactivate.do", {"enrollmentId":enrollId}, function(result) {
            Common.alert("<b>This batch "+ enrollId +" has been deactivated.</b>");
            //fn_openDivPop('VIEW');
            hideViewPopup('#view_wrap');

        },function(result) {
            Common.alert("<b>Failed to deactivate this batch " + enrollId + ". <br />Please try again later.</b>");
        });
    })

}
</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>H2H E-Enrollment </h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="javascript:fn_getEEnrollList();"><span class="search"></span>Search</a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_clear();"><span class="clear"></span>Clear</a></p></li>
        </ul>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm"  method="post">

            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:140px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:170px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Enroll ID</th>
                        <td>
                            <input id="enrollmentId" name="enrollmentId" type="text" title="enrollmentId" placeholder="Enroll ID" class="w100p" />
                        </td>
                        <th scope="row">Creator</th>
                        <td>
                           <input id="creator" name="creator" type="text" title="Creator" placeholder="Creator (Username)" class="w100p" />
                        </td>
                        <th scope="row">Create Date</th>
                        <td>
                            <!-- date_set start -->
                            <div class="date_set w100p">
                                <p><input id="createDt1" name="createDt1" type="text" title="Create Date From" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
                                <span>~</span>
                                <p><input id="createDt2" name="createDt2" type="text" title="Create Date To" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
                            </div>
                            <!-- date_set end -->
                        </td>
                    </tr>
                    <tr>
                       <th scope="row">Status</th>
                        <td>
                           <select id="status" name="status" class="w100p">
                           <option value="1">Active</option>
                                <option value="4">Completed</option>
                                <option value="8">Inactive</option>
                                <option value="21">Failed</option>
                           </select>
                        </td>
                          <th scope="row">Issue Bank</th>
                        <td>
                           <select id="issueBank" name="issueBank" class="w100p">
                           <option value="3" selected="selected">CIMB Bank</option>
                           </select>
                        </td>
                        <th scope="row">Debit Date</th>
                        <td>
                           <!-- date_set start -->
                            <div class="date_set w100p">
                                <p><input id="debitDt1" name="debitDt1" type="text" title="Debit Date From" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
                                <span>~</span>
                                <p><input id="debitDt2" name="debitDt2" type="text" title="Debit Date To" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
                            </div>
                            <!-- date_set end -->
                        </td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->

            <!-- link_btns_wrap start -->
            <aside class="link_btns_wrap">
                <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
                <dl class="link_list">
                    <dt>Link</dt>
                    <dd>
                    <ul class="btns">
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('VIEW');">View eEnrollment</a></p></li>
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('NEW');">New eEnrollment</a></p></li>
                        <li><p class="link_btn"><a href="javascript:fn_openDivPop('FILE');">Manage eEnrollment File</a></p></li>
                    </ul>
                    <ul class="btns">
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                    </dd>
                </dl>
            </aside>
            <!-- link_btns_wrap end -->
        </form>
    </section>
    <!-- search_table end -->

    <!-- search_result start -->
    <section class="search_result">

        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->

    </section>
    <!-- search_result end -->

</section>
<!-- content end -->

<!-------------------------------------------------------------------------------------
    POP-UP (VIEW CLAIM / RESULT (Live) / RESULT (NEXT DAY) / FILE GENERATOR
-------------------------------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="view_wrap" style="display: none;">
    <!-- pop_header start -->
    <header class="pop_header" id="pop_header">
        <h1></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2">
                    <a href="#" onclick="hideViewPopup('#view_wrap')">CLOSE</a>
                </p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <section class="pop_body">
        <!-- tap_wrap start -->
        <section class="tap_wrap mt0">
            <ul class="tap_type1">
                <li><a href="#" class="on">Batch eEnrollment Info</a></li>
                <li><a href="#">Batch eEnrollment Item</a></li>
            </ul>

    <!-- <section class="search_table"> search_table start -->
            <!-- #########Batch Deduction Info######### -->
            <article class="tap_area"><!-- tap_area start -->
                <!-- table start -->
                <table class="type1">
                    <caption>table</caption>
                    <colgroup>
                        <col style="width: 165px" />
                        <col style="width: *" />
                        <col style="width: 165px" />
                        <col style="width: *" />
                    </colgroup>
                    <tbody>
                        <tr>
                            <th scope="row">Enroll ID</th>
                            <td id="view_enrollmentId"></td>
                            <th scope="row">Batch Status</th>
                            <td id="view_stusName"></td>
                        </tr>
                        <tr>
                            <th scope="row">Deduction Date From</th>
                            <td id="view_debtDt"></td>
                            <th scope="row">Total Records</th>
                            <td id="view_totRec"></td>
                        </tr>
                        <tr>
                            <th scope="row">Issue Bank</th>
                            <td colspan="3" id="view_issueBank"></td>

                        </tr>
                        <!-- <tr>
                            <th scope="row">Total Enrolled</th>
                            <td id=""></td>
                            <th scope="row">Total Active</th>
                            <td id=""></td>
                        </tr> -->
                        <tr>
                            <th scope="row">Created Date</th>
                            <td id="view_crtDt"></td>
                            <th scope="row">Creator</th>
                            <td id="view_crtName"></td>
                        </tr>
                        <tr>
                            <th scope="row">Updated Date</th>
                            <td id="view_updDt"></td>
                            <th scope="row">Updator</th>
                            <td id="view_updName"></td>
                        </tr>
                    </tbody>
                </table>

                <ul class="center_btns" id="center_btns1">
                    <li><p class="btn_blue2"><a href="javascript:fn_deactivate();">Deactivate</a></p></li>

                    <li><p class="btn_blue2"><a href="javascript:fn_createFile();">Generate File</a></p></li>
                </ul>

            </article>
            <!-- #########Batch Deduction Item######### -->
            <article class="tap_area">
                <!-- tap_area start -->
                <!-- table start -->
                    <!-- grid_wrap start -->
                    <aside class="title_line"><!-- title_line start -->
                    <header class="pop_header" id="pop_header">
                    <h3></h3>
                        <ul class="right_btns">
                            <li><p class="btn_blue2"><a href="javascript:fn_getItmStatus('')">All Records</a></p></li>
                            <li><p class="btn_blue2"><a href="javascript:fn_getItmStatus(4)">Completed Enrollments</a></p></li>
                            <li><p class="btn_blue2"><a href="javascript:fn_getItmStatus(1)">Active Enrollments</a></p></li>
                        </ul>
                     </header>
                    </aside><!-- title_line end -->

                    <table class="type1">
                        <caption>table</caption>
                        <tbody>
                            <tr>
                                <td colspan='5'>
                                    <div id="enrollmentItem_grid_wrap" style="width: 100%; height: 480px; margin: 0 auto;"></div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <!-- table end -->
                </article>
                <!-- grid_wrap end -->
            <!-- tap_area end -->
            <!-- </section> search_table end -->
        </section>
        <!-- tap_wrap end-->
    </section>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->

<!---------------------------------------------------------------
    POP-UP (NEW ECASH AUTO DEBIT DEDUCTION)
---------------------------------------------------------------->
<!-- popup_wrap start -->
<div class="popup_wrap" id="new_wrap" style="display:none;">
    <!-- pop_header start -->
    <header class="pop_header" id="new_pop_header">
        <h1>NEW H2H E-ENROLLMENT</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#" onclick="hideViewPopup('#new_wrap')">CLOSE</a></p></li>
        </ul>
    </header>
    <!-- pop_header end -->

    <!-- pop_body start -->
    <form name="newForm" id="newForm"  method="post">
    <section class="pop_body">
        <!-- search_table start -->
        <section class="search_table">
            <!-- table start -->
            <table class="type1">
                <caption>table</caption>
                 <colgroup>
                    <col style="width:165px" />
                    <col style="width:*" />
                    <col style="width:165px" />
                    <col style="width:*" />
                </colgroup>

                <tbody>
                    <tr>
                        <th scope="row">Issue Bank <span class="must">*</span></th>
                        <td>
                            <select id="new_issueBank" name="new_issueBank" class="w100p">
                             <option value="3" selected="selected">CIMB Bank</option>
                            </select>
                        </td>
                        <th scope="row">Debit Date<span class="must">*</span></th>
                        <td colspan="3">
                            <div class="date_set w105p">
                                <!-- date_set start -->
                                                  <p><input id="debitDt3" name="debitDt3" type="text" title="Debit Date To" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
                                </div>
                    </tr>
                   </tbody>
            </table>
        </section>
        <!-- search_table end -->

        <ul class="center_btns">
            <li><p class="btn_blue2"><a href="javascript:fn_genClaim();">Generate File</a></p></li>
        </ul>
    </section>
    </form>
    <!-- pop_body end -->
</div>
<!-- popup_wrap end -->

