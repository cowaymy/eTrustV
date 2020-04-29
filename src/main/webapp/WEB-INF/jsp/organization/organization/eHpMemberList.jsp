<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID;
var grpOrgList = new Array(); // Group Organization List
var orgList = new Array(); // Organization List
var selRowIndex;
var userType = '${SESSION_INFO.userTypeId}';

var selectedGridValue;

function fn_memberListNew(){
     Common.popupDiv("/organization/selectEHPMemberListNewPop.do?isPop=true", "eHPsearchForm"  ,null , true  ,'fn_memberListNew');
}

function fn_memberListSearch(){
    selRowIndex = null;

    var jsonObj =  {
    		   eHPmemTypeCom : $("#eHPmemTypeCom").val(),
    		   eHPcode : $("#eHPcode").val(),
    		   eHPname : $("#eHPname").val(),
    		   eHPicNum : $("#eHPicNum").val(),
    			   eHPbirth : $("#eHPbirth").val(),
    			   eHPnation : $("#eHPnation").val(),
    			   eHPrace : $("#eHPrace").val(),
    			   eHPstatus : $("#eHPstatus").val(),
    			   eHPcontact : $("#eHPcontact").val(),
    			   eHPcollectionBrnch : $("#eHPcollectionBrnch").val(),
    			   eHPkeyUser : $("#eHPkeyUser").val(),
    			   eHPkeyBranch : $("#eHPkeyBranch").val(),
    			   eHPcreateDate : $("#eHPcreateDate").val(),
    			   eHPendDate : $("#eHPendDate").val()
    }
    console.log("-------------------------" + JSON.stringify(jsonObj));
    Common.ajax("GET", "/organization/eHpMemberListSearch", jsonObj, function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID, result);
    });

}

function fn_excelDown(){
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("grid_wrap_eHPmemList", "xlsx", "eHPMemberList");
}

function fn_clickHpApproval(){

    $("#eHPaplcntCode").val(membercode);
    $("#eHPaplcntNRIC").val(nric);

    // Added checking if applicant agreed agreement - Kit Wai
    Common.ajax("GET", "/organization/getApplicantInfo", $("#eHpApplicantValidateForm").serialize(), function(result) {
        console.log(result);

        if(result.stus == "102" && result.cnfm == "1" && result.cnfm_dt != "1900-01-01") {
            //Common.confirm("Do you want to approve the HP? <br/> Member Code :  "+membercode+"  <br/> Name :"+ memberName , fn_hpMemRegisPop );
            Common.confirm(result.aplicntName + "</br>" +
                                   result.aplicntNric + "</br>" +
                                   result.bnkNm + "</br>" +
                                   "A/C : " + result.aplicntBankAccNo + "</br></br>" +
                                   "Do you want to approve with above information?", fn_hpMemRegisPop);
        } else if (result.stus == "44" && result.cnfm == "0" && result.cnfm_dt == "1900-01-01") {
            Common.alert("Applicant has not accepted agreement.");
        } else if(result.stus == "6") {
            Common.alert("Aplicant has rejected agreement");
        } else if(result.stus == "5") {
            Common.alert("Aplicant has already been approved.");
        } else if(result.stus == "98") {
            Common.alert("Aplicant has been automatically cancelled.");
        }


        if(result.stus == "44" && result.cnfm == "0" && result.cnfm_dt == "1900-01-01") {
            Common.alert("Only accepted agreement applicants may become members.")
        } else {
            //Common.confirm("Do you want to approve the HP? <br/> Member Code :  "+membercode+"  <br/> Name :"+ memberName , fn_hpMemRegisPop );
            Common.confirm(result.aplicntName + "</br>" +
                                   result.aplicntNric + "</br>" +
                                   result.bnkNm + "</br>" +
                                   "A/C : " + result.aplicntBankAccNo + "</br></br>" +
                                   "Do you want to approve with above information?", fn_hpMemRegisPop);
        }
    })
}

function fn_clickHpReject(){
      Common.confirm("Do you want to reject the HP? <br/> Member Code :  "+membercode+"  <br/> Name :"+ memberName , function() {
          if($("#userRole").val() == 111 || $("#userRole").val() == 112 || $("#userRole").val() == 113 || $("#userRole").val() == 114) {
              if(statusName == "Pending") {
                  fn_RejectHPMem();
              } else {
                  Common.alert("Member cancellation is not allowed under READY / APPROVED status");
              }
          } else if($("#userRole").val() != 111 || $("#userRole").val() != 112 || $("#userRole").val() != 113 || $("#userRole").val() != 114) {
              if(statusName == "Pending" || statusName == "Ready") {
                  fn_RejectHPMem();
              } else {
                  Common.alert("Member cancellation is not allowed under READY / APPROVED status");
              }
          }
      });
}

function fn_hpMemRegisPop(){
     var jsonObj = {
             MemberID :memberid,
            MemberType : memberType,
            MemberCode : membercode
    };

    if (memberType == "2803" ) {
        if ( statusName == "Ready" ) {

         Common.ajax("GET", "/organization/hpMemRegister.do", {memberId:memberid ,memberType:memberType, nric:nric, MemberCode : membercode }, function(result) {
             console.log("성공.");
             console.log( result);

             if(result !="" ){
                 if (result.message == "There is no address information to the HP applicant code") {
                     Common.alert(result.message);
                 } else if (result.message.substr(0, 33) == "This member is already registered") {
                     Common.alert(result.message);
                 } else {
                     Common.alert(" Health Planner registration has been completed. <br/>Member Code : "+membercode+"  to  "+ result.message );
                     fn_memberListSearch();

                     var newMemCode = result.message;

                     var today = new Date();
                     var dd = today.getDate();
                     var mm = today.getMonth() + 1;
                     var yy = today.getFullYear();
                     if(dd < 10) {
                         dd = '0' + dd;
                     }
                     if(mm < 10) {
                         mm = '0' + mm;
                     }
                     today = dd + '/' + mm + '/' + yy;

                    // Construct approved SMS
                     var apprSms = " COWAY: WELCOME to COWAY family! " +
                                          "Your application for COWAY HP is completed. Your COWAY HP code " + newMemCode + " is ACTIVATED on " + today + ". TQ!";

                     Common.ajax("GET", "/organization/getHPCtc", {src: "member", memCode: newMemCode}, function(result1) {
                         var mobile = result1.mobile;
                         //var email = result1.email;

                         if(mobile != "") {
                             Common.ajax("GET", "/services/as/sendSMS.do",{rTelNo:mobile , msg :apprSms} , function(result) {
                                 console.log("sms.");
                                 console.log( result);
                             });
                         }
                     })
                 }
             }

         });
        } else {
            Common.alert("Only available to entry Ready is in a case of Status");
        }
    } else {
        Common.alert("Only available to entry with HP Approval is in a case of HP Applicant");
    }
}

function fn_RejectHPMem(){
     if (memberType == "2803" ) {
         Common.ajax("GET", "/organization/hpMemReject.do", {memberId:memberid ,memberType:memberType, nric:nric }, function(result) {
             if(result.message == "success"){
                   Common.alert("Successfully reject HP Applicant :" + membercode);

                   var today = new Date();
                    var dd = today.getDate();
                    var mm = today.getMonth() + 1;
                    var yy = today.getFullYear();
                    if(dd < 10) {
                        dd = '0' + dd;
                    }
                    if(mm < 10) {
                        mm = '0' + mm;
                    }
                    today = dd + '/' + mm + '/' + yy;

                     // Construct approved SMS
                    var apprSms = " COWAY: Sorry to inform that your application for " +
                                         "COWAY HP has been REJECTED on " + today + ". Kindly refer to your sponsor for enquiry. TQ!";

                    Common.ajax("GET", "/organization/getHPCtc", {src: "aplicant", memCode: membercode}, function(result1) {
                        var mobile = result1.mobile;
                        //var email = result1.email;

                        if(mobile != "") {
                            Common.ajax("GET", "/services/as/sendSMS.do",{rTelNo:mobile , msg :apprSms} , function(result) {
                                console.log("sms.");
                                console.log( result);
                            });
                        }
                    })
                 }
             });
        } else {
            Common.alert("Only available to entry with HP Reject is in a case of HP Applicant");
        }
}

function fn_clickHpStatusUpdate(){

	if( statusName == "Approved" || statusName == "Rejected" ||  statusName == "Cancelled"  || statusName == "Completed" || statusName == "Pending"  ){
		Common.alert("Not allow to Update Status for HP Applicant with status " + statusName );
	}
/* 	else if(userType != "1" && statusName == "Pending" ){
		Common.alert("Not allow to Update Status for HP Applicant with status " + statusName );
	} */
	else{
        Common.popupDiv("/organization/eHpMemberUpdateStatusPop.do?isPop=true&memberCode=" + membercode+"&MemberID=" + memberid+"&memType=" + memberType  , "");
	}
}

//Start AUIGrid --start Load Page- user 1st click Member
$(document).ready(function() {

    // AUIGrid 그리드를 생성합니다.
    createAUIGrid();

   // AUIGrid.setSelectionMode(myGridID, "singleRow");

 // 셀 더블클릭 이벤트 바인딩
      AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
            //alert(event.rowIndex+ " - double clicked!! : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid"));
            Common.popupDiv("/organization/selectEHPMemberListDetailPop.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype")+"&atchFileGrpId="+AUIGrid.getCellValue(myGridID, event.rowIndex, "atchFileGrpId") , "");
        });

     AUIGrid.bind(myGridID, "cellClick", function(event) {
        selRowIndex = event.rowIndex;
        //alert(event.rowIndex+ " -cellClick : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid"));
        memberid =  AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid");
        memberType = AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype");
        membercode = AUIGrid.getCellValue(myGridID, event.rowIndex, "membercode");
        statusName = AUIGrid.getCellValue(myGridID, event.rowIndex, "statusName");
        traineeType = AUIGrid.getCellValue(myGridID, event.rowIndex, "traineeType");
        nric = AUIGrid.getCellValue(myGridID, event.rowIndex, "nric");
        memberName = AUIGrid.getCellValue(myGridID, event.rowIndex, "name");
        testResult = AUIGrid.getCellValue(myGridID, event.rowIndex, "testResult");
        atchFileGrpId = AUIGrid.getCellValue(myGridID, event.rowIndex, "atchFileGrpId");
        //Common.popupDiv("/organization/requestTerminateResign.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype"), "");
    });

    $("#eHPposition").attr("disabled",true);


 });

function createAUIGrid() {
        //AUIGrid 칼럼 설정
        var columnLayout = [ {
            dataField : "codename",
            headerText : "Type Name",
            editable : true,
            width : 130
        }, {
            dataField : "memberid",
            headerText : "MemberID",
            editable : false,
            width : 0
        }, {
            dataField : "membercode",
            headerText : "Member Code",
            editable : false,
            width : 130
        }, {
            dataField : "name",
            headerText : "Member Name",
            editable : false,
            width : 130
        }, {
            dataField : "nric",
            headerText : "Member NRIC",
            editable : false,
            style : "my-column",
            width : 130
        }, {
            dataField : "statusName",
            headerText : "Status",
            editable : false,
            width : 130
        }, {
            dataField : "crtUsrId",
            headerText : "Creator User ID",
            editable : false,
            width : 130
        }, {
            dataField : "testResult",
            headerText : "Test Result",
            editable : false,
            width : 0,
            visible : false
        }, {
            dataField : "atchFileGrpId",
            headerText : "Attach File Grp ID",
            editable : false,
            width : 0,
            visible : false
        }, {
            dataField : "updated",
            headerText : "Last Update",
            editable : false,
            width : 130

        },{
            dataField : "resnDesc",
            headerText : "Fail Reason Desc",
            editable : false,
            width : 180

        },{
            dataField : "rem",
            headerText : "Fail Remark",
            editable : false,
            width : 180

        },{
            dataField : "stusUpdId",
            headerText : "Update Status By",
            editable : false,
            width : 130

        },{
            dataField : "membertype",
            headerText : "Member Type",
            width : 0 ,
            visible : false
        },
        {
            dataField : "traineeType",
            headerText : "Trainee Type",
            width : 0,
            visible : false
        },
        {
            dataField : "approvedBy",
            headerText : "Approved by",
            editable : false,
            width : 130
        },
        {
            dataField : "crtDt",
            headerText : "Action Date",
            editable : false,
            width : 130
        },
        {
            dataField : "branch",
            headerText : "Approved Branch",
            editable : false,
            width : 130 ,
            visible : false
        },
        {
            dataField : "address",
            headerText : "Address",
            editable : false,
            width : 130 ,
            visible : false
        },
        {
            dataField : "deptCode",
            headerText : "Group Code",
            editable : false,
            width : 130
        }];


         // 그리드 속성 설정
        var gridPros = {

                 usePaging           : true,         //페이징 사용
                 pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
                 editable            : false,
                 fixedColumnCount    : 1,
                 showStateColumn     : false,
                 displayTreeOpen     : false,
                // selectionMode       : "singleRow",  //"multipleCells",
                 headerHeight        : 30,
                 useGroupingPanel    : false,        //그룹핑 패널 사용
                 skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                 wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                 showRowNumColumn    : true       //줄번호 칼럼 렌더러 출력
        };

        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
        myGridID = AUIGrid.create("#grid_wrap_eHPmemList", columnLayout, gridPros);
    }





function fn_memberEditPop(){
    if( statusName == "Approved" ||statusName == "Cancelled"   ){
        Common.alert("Not allow to Update Status for HP Applicant with status " + statusName );
    }else{
         Common.popupDiv("/organization/eHpMemberListEditPop.do?isPop=true&memberCode=" + membercode+"&MemberID=" + memberid+"&memType=" + memberType + "&atchFileGrpId=" + atchFileGrpId , "");
    }
       }

function fn_searchPosition(selectedData){
    $("#eHPposition option").remove();
      if(selectedData == "2" || selectedData =="3" || selectedData =="1" || selectedData =="7" || selectedData =="5758"){
           $("#eHPposition").attr("disabled",false);   /*position button enable*/
           Common.ajax("GET",
                    "/organization/positionList.do",
                    "memberType="+selectedData,
                    function(result) {
                        $("#eHPposition").append("<option value=''>Select Position</option> " );
                        for(var idx=0; idx < result.length ; idx++){
                            $("#eHPposition").append("<option value='" +result[idx].positionLevel+ "'> "+result[idx].positionName+ "</option>");
                        }
                    }
           );
       }else{
           /*position button disable*/
           $("#eHPposition").attr("disabled",true);
           /* If you want to set position default value remove under comment.*/
           $("#eHPposition").append("<option value=''>Select Account</option> " );

       }
}


</script>

<!-- --------------------------------------DESIGN------------------------------------------------ -->

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>Member</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>eHP</h2>
<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_memberListNew();">New</a></p></li>
</c:if>
    <li><p class="btn_blue"><a href="javascript:fn_memberListSearch();"><span class="search"></span>Search</a></p></li>
<c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_memberEditPop()">Edit</a></p></li>
</c:if>
 <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_clickHpApproval()">HP Approval</a></p></li>
</c:if>
 <c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_clickHpReject()">HP Reject</a></p></li>
</c:if>
 <c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_clickHpStatusUpdate()">Update Status</a></p></li>
</c:if>

</ul>
</aside><!-- title_line end -->

<input type="hidden" id="eHPuserRole" name="userRole" value="${userRole} " />
<input type="hidden" id="eHPaplctUrl" name="aplctUrl" style="visible:false"/>

<section class="search_table"><!-- search_table start -->
<form action="#" id="eHPsearchForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Type</th>
    <td>

    <!-- By KV start - when memtypecom selected item then go to fn_searchPosition function-->
    <select class="w100p" id="eHPmemTypeCom" name="memTypeCom" onchange="fn_searchPosition(this.value)" disabled="disabled">
        <!-- <option value="1" >HP </option> -->
        <option value="2803" selected>HP Applicant</option>
    </select>
    </td>
    <th scope="row">Code</th>
    <td>
    <input type="text" title="Code" placeholder="" class="w100p" id="eHPcode" name="code" />
    </td>
    <th scope="row">Name</th>
    <td>
    <input type="text" title="Name" placeholder="" class="w100p" id="eHPname" name="name" />
    </td>
    <th scope="row">IC Number</th>
    <td>
    <input type="text" title="IC Number" placeholder="" class="w100p" id="eHPicNum" name="icNum" />
    </td>
</tr>
<%--<tr>
    <th scope="row">Date Of Birth</th>
    <td>
    <input type="text" title="Date Of Birth"  placeholder="DD/MM/YYYY"  class="j_date"  id="eHPbirth" name="birth"/>
    </td>
    <th scope="row">Nationality</th>
    <td>
    <select class="w100p" id="eHPnation" name="nation">
        <option value="" selected>Select Account</option>
         <c:forEach var="list" items="${nationality }" varStatus="status">
           <option value="${list.countryid}">${list.name}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Race</th>
    <td>
    <select class="w100p" id="eHPrace" name="race">
        <option value="" selected>Select Account</option>
        <c:forEach var="list" items="${race }" varStatus="status">
           <option value="${list.detailcodeid}">${list.detailcodename}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Status</th>
    <td>
    <select class="w100p" id="eHPstatus" name="status">
        <option value="" selected>Select Account</option>
        <c:forEach var="list" items="${status }" varStatus="status">
           <option value="${list.statuscodeid}">${list.name}</option>
        </c:forEach>
    </select>
    </td>
</tr>--%>
<tr>
<th scope="row">Status</th>
    <td>
    <select class="w100p" id="eHPstatus" name="status">
        <option value="" selected>Select Account</option>
        <c:forEach var="list" items="${status }" varStatus="status">
           <option value="${list.statuscodeid}">${list.name}</option>
        </c:forEach>
    </select>
    </td>

    <th scope="row">Contact No</th>
    <td>
    <input type="text" title="Contact No" placeholder="" class="w100p" id="eHPcontact" name="contact"/>
    </td>

<%--     <th scope="row">Position</th>
    <td>
    <select class="w100p" id="eHPposition" name="position">
        <option value="" selected>Select Account</option>
        <c:forEach var="list" items="${position}" varStatus="status">
            <option value="${list.positionLevel}">${list.positionName}</option>
        </c:forEach>
    </select>
    </td> --%>


    <th scope="row">Collection Branch </th>
    <td>
    <select class="w100p" id="eHPcollectionBrnch" name="collectionBrnch">
        <option value="" selected>Select Branch</option>
        <c:forEach var="list" items="${SOBranch }" varStatus="status">
           <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row"></th>
    <td>
    </td>
</tr>
<tr>
<%--     <th scope="row">Key-In User</th>
    <td>
    <select class="w100p" id="eHPkeyUser" name="keyUser">
        <option value="" selected>Select Account</option>
        <c:forEach var="list" items="${user }" varStatus="status">
           <option value="${list.userid}">${list.username}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Key-In User Branch</th>
    <td>
    <select class="w100p" id="eHPkeyBranch" name="keyBranch">
    <option value="" selected>Select Account</option>
        <c:forEach var="list" items="${userBranch }" varStatus="status">
           <option value="${list.branchid}">${list.c1}</option>
        </c:forEach>
    </select>
    </td> --%>
    <th scope="row">Key-In Date</th>
    <td colspan="3">

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="eHPcreateDate" name="createDate" /></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date"  id="eHPendDate" name="endDate"/></p>
    </div><!-- date_set end -->

    </td>
</tr>
</tbody>
</table><!-- table end -->


</form>
</section><!-- search_table end -->

<form id="eHpApplicantValidateForm" method="post">
    <div style="display:none">
        <input type="text" name="aplcntCode"  id="eHPaplcntCode"/>
        <input type="text" name="aplcntNRIC"  id="eHPaplcntNRIC"/>
    </div>
</form>

 <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
    <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
    <dl class="link_list">
        <dt><spring:message code="sal.title.text.link" /></dt>
        <dd>

        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
        </dd>
    </dl>
    </aside><!-- link_btns_wrap end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
<li><p class="btn_grid"><a href="javascript:fn_excelDown();">GENERATE</a></p></li>
</c:if>
   <!--  <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>

    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li> -->
</ul>

<article class="grid_wrap">
    <!-- grid_wrap start -->
    <div id="grid_wrap_eHPmemList" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

<aside class="bottom_msg_box"><!-- bottom_msg_box start -->
<p>Information Message Area</p>
</aside><!-- bottom_msg_box end -->

</section><!-- container end -->

</div><!-- wrap end -->
