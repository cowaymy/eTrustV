<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID;
var grpOrgList = new Array(); // Group Organization List
var orgList = new Array(); // Organization List

function fn_memberListNew(){
	 Common.popupDiv("/organization/selectMemberListNewPop.do?isPop=true", "searchForm"  ,null , true  ,'fn_memberListNew');
}

function fn_memberListSearch(){
 	Common.ajax("GET", "/organization/memberListSearch", $("#searchForm").serialize(), function(result) {
        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID, result);
    });

}

function fn_excelDown(){
	// type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("grid_wrap_memList", "xlsx", "MemberList");
}

function fn_TerminateResign(val){

console.log( memberType )



	if(val == '1'){
        if (memberType == 1 || memberType == 2 || memberType == 3 || memberType == 4 ) {	
			 var jsonObj = {
					     MemberID :memberid,
			            MemberType : memberType
			    };
			console.log("MemberID="+memberid+"&MemberType="+memberType+"&codeValue=1");
			Common.popupDiv("/organization/requestTerminateResign.do?isPop=true&MemberID="+memberid+"&MemberType="+memberType+"&codeValue=1", null ,null , true  ,'_fn_TerminateResignDiv');
		} else {
            Common.alert("Only available to entry with Terminate/Resign Request in regular type of member");
		}
	}else{
	   if (memberType == 1 || memberType == 2 || memberType == 3 || memberType == 4 ) {
	        var jsonObj = {
	                 MemberID :memberid,
	                MemberType : memberType
	        };
			console.log("MemberID="+memberid+"&MemberType="+memberType+"&codeValue=2");
	        Common.popupDiv("/organization/requestTerminateResign.do?isPop=true&MemberID="+memberid+"&MemberType="+memberType+"&codeValue=2" , null ,null , true  ,'_fn_TerminateResignDiv');
		} else {
		    Common.alert("Only available to entry with Promote/Demote Request in regular type of member");
		}        
	}
 
}

/*By KV start - requestVacationPop*/
function fn_requestVacationPop(){
	 var jsonObj = {
             MemberID :memberid,
            MemberType : memberType
    };
    
    console.log("MemberID="+memberid+"&MemberType="+memberType);
    
    if (memberType == 3 ) {
        Common.popupDiv("/organization/requestVacationPop.do?isPop=true&MemberID="+memberid+"&MemberType="+memberType ,  null ,null , true  ,'_fn_requestVacationPopDiv');
    }else {
        Common.alert("Only available to entry with request vacation in case of CT member");
    }
}
/*By KV end - requestVacationPop*/


/*By KV start - traineeToMemberRegistPop*/
 function fn_confirmMemRegisPop(){
     var jsonObj = {
             MemberID :memberid,
            MemberType : memberType
    };
    //Common.popupDiv("/organization/confirmMemRegisPop.do?isPop=true&MemberID="+memberid+"&MemberType="+memberType);
    
    console.log(memberid + " :: " + memberType + " :: " + traineeType)
    
    if ( memberType == 5 && (traineeType == 2 || traineeType == 3)) {
    
     Common.ajax("GET", "/organization/traineeUpdate.do", {memberId:memberid ,memberType:memberType }, function(result) {
         console.log("성공.");
         console.log( result);

         if(result !="" ){
             //Common.alert(" New Cody registration has been completed from "+membercode+" to "+ result.message);
                 if ( traineeType == 2) {
			        Common.alert(" Cody registration has been completed. "+membercode+" to "+ result.message);
			    }
			    
			    if ( traineeType == 3) {
			        Common.alert(" CT  registration has been completed. "+membercode+" to "+ result.message);
			    } 
        	  fn_memberListSearch();
         }
     });
    }else {
        Common.alert("Only available to entry with Confirm Member Registration in Case of Trainee Type");
    }
}

function fn_hpMemRegisPop(){
     var jsonObj = {
             MemberID :memberid,
            MemberType : memberType
    };
    
    if (memberType == "2803" ) {
    	if ( statusName == "Pending" ) {
    
	     Common.ajax("GET", "/organization/hpMemRegister.do", {memberId:memberid ,memberType:memberType }, function(result) {
	         console.log("성공.");
	         console.log( result);
	
	         if(result !="" ){
	             Common.alert(" Health Planner registration has been completed. { "+membercode+" } to { "+ result.message +" }");
	              fn_memberListSearch();
	         }
	     });
        } else {
	        Common.alert("Only available to entry with HP Approval is in a case of HP Applicant");
	    }     
    } else {
    	Common.alert("Only available to entry with HP Approval is in a case of HP Applicant");
    }

}

/*By KV end - traineeToMemberRegistPop*/



//Start AUIGrid --start Load Page- user 1st click Member
$(document).ready(function() {

    // AUIGrid 그리드를 생성합니다.
    createAUIGrid();

    AUIGrid.setSelectionMode(myGridID, "singleRow");

 // 셀 더블클릭 이벤트 바인딩
	  AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
	        //alert(event.rowIndex+ " - double clicked!! : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid"));
	        Common.popupDiv("/organization/selectMemberListDetailPop.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype"), "");
	    });

     AUIGrid.bind(myGridID, "cellClick", function(event) {
        //alert(event.rowIndex+ " -cellClick : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid"));
    	memberid =  AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid");
        memberType = AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype");
        membercode = AUIGrid.getCellValue(myGridID, event.rowIndex, "membercode");
        statusName = AUIGrid.getCellValue(myGridID, event.rowIndex, "statusName");
        traineeType = AUIGrid.getCellValue(myGridID, event.rowIndex, "traineeType");
        
    	//Common.popupDiv("/organization/requestTerminateResign.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype"), "");
    });

    /*By KV Start  - Position button disable function in selection*/
    $("#position").attr("disabled",true);
    /*By KV End - Position button disable function in selection*/

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
		    width : 130
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
		    dataField : "updated",
		    headerText : "Last Update",
		    editable : false,
		    width : 130

		},
		/*BY KV Position*/
		{
            dataField : "positionName",
            headerText : "Position Desc",
            editable : false,
            width : 130

        },
        {
            dataField : "membertype",
            headerText : "Member Type",
            width : 0
		},
		{
            dataField : "traineeType",
            headerText : "Trainee Type",
            width : 0
        }		
		/* this is for put EDIT button in grid ,
        {
            dataField : "undefined",
            headerText : "Edit",
            width : 170,
            renderer : {
                  type : "ButtonRenderer",
                  labelText : "Edit",
                  onclick : function(rowIndex, columnIndex, value, item) {
                       //pupupWin
                      $("#_custId").val(item.custId);
                      $("#_custAddId").val(item.custAddId);
                      $("#_custCntcId").val(item.custCntcId);
                      Common.popupDiv("/sales/customer/updateCustomerBasicInfoPop.do", $("#popForm").serializeJSON(), null , true , '_editDiv1');
                      }
             }
        } */];


		 // 그리드 속성 설정
        var gridPros = {

        		 usePaging           : true,         //페이징 사용
                 pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
                 editable            : false,
                 fixedColumnCount    : 1,
                 showStateColumn     : false,
                 displayTreeOpen     : false,
                 selectionMode       : "singleRow",  //"multipleCells",
                 headerHeight        : 30,
                 useGroupingPanel    : false,        //그룹핑 패널 사용
                 skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                 wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                 showRowNumColumn    : true       //줄번호 칼럼 렌더러 출력
        };

        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
        myGridID = AUIGrid.create("#grid_wrap_memList", columnLayout, gridPros);
    }

var gridPros = {

        // 페이징 사용
        usePaging : true,

        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount : 20,

        editable : true,

        fixedColumnCount : 1,

        showStateColumn : true,

        displayTreeOpen : true,

        selectionMode : "singleRow",

        headerHeight : 30,

        // 그룹핑 패널 사용
        useGroupingPanel : true,

        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,

        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,

        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : false

    };


function fn_memberEditPop(){
	     //Common.popupDiv("/organization/memberListEditPop.do?isPop=true", "searchForm");
	     Common.popupDiv("/organization/memberListEditPop.do?isPop=true&memberCode=" + membercode+"&MemberID=" + memberid+"&MemberType=" + memberType, "");
	     //Common.popupDiv("/organization/memberListEditPop.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype"), "");
}




/*By KV start - Position - This is for display Position data only in Position selection.*/
function fn_searchPosition(selectedData){
	$("#position option").remove();
	  if(selectedData == "2" || selectedData =="3" || selectedData =="1"){
		   $("#position").attr("disabled",false);   /*position button enable*/
		   Common.ajax("GET",
				    "/organization/positionList.do",
				    "memberType="+selectedData,
				    function(result) {
				    	/* By KV - user able use "select account" */
				    	$("#position").append("<option value=''>Select Position</option> " );
				        for(var idx=0; idx < result.length ; idx++){
				            $("#position").append("<option value='" +result[idx].positionLevel+ "'> "+result[idx].positionName+ "</option>");
				        }
				    }
		   );
	   }else{
		   /*position button disable*/
		   $("#position").attr("disabled",true);
		   /* If you want to set position default value remove under comment.*/
		   $("#position").append("<option value=''>Select Account</option> " );

	   }
}
/*By KV end - Position - This is for display Position data only in Position selection.*/

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
<h2>Member</h2>
<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_memberListNew();">New</a></p></li>
</c:if>
<c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_memberListSearch();"><span class="search"></span>Search</a></p></li>
</c:if>    
<c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_TerminateResign('1')">Request Terminate/Resign</a></p></li>
</c:if>    
<c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_TerminateResign('2')">Request Promote/Demote</a></p></li>
</c:if>    
<c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_memberEditPop()">Member Edit</a></p></li>
</c:if>    
<c:if test="${PAGE_AUTH.funcUserDefine5 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_requestVacationPop()">Request Vacation </a></p></li>
</c:if>   
 <c:if test="${PAGE_AUTH.funcUserDefine6 == 'Y'}">
    <li><p class="btn_blue"><a href="javascript:fn_confirmMemRegisPop()">Confirm Member Registration </a></p></li>
</c:if>  
 <c:if test="${PAGE_AUTH.funcUserDefine7 == 'Y'}">  
    <li><p class="btn_blue"><a href="javascript:fn_hpMemRegisPop()">HP Approval</a></p></li>
</c:if>    
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" id="searchForm" method="post">

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
    <select class="w100p" id="memTypeCom" name="memTypeCom" onchange="fn_searchPosition(this.value)">
     <!-- By KV end - when memtypecom selected item then go to fn_searchPosition function-->

        <option value="" selected>Select Account</option>
         <c:forEach var="list" items="${memberType }" varStatus="status">
           <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Code</th>
    <td>
    <input type="text" title="Code" placeholder="" class="w100p" id="code" name="code" />
    </td>
    <th scope="row">Name</th>
    <td>
    <input type="text" title="Name" placeholder="" class="w100p" id="name" name="name" />
    </td>
    <th scope="row">IC Number</th>
    <td>
    <input type="text" title="IC Number" placeholder="" class="w100p" id="icNum" name="icNum" />
    </td>
</tr>
<tr>
    <th scope="row">Date Of Birth</th>
    <td>
    <input type="text" title="Date Of Birth"  placeholder="DD/MM/YYYY"  class="j_date"  id="birth" name="birth"/>
    </td>
    <th scope="row">Nationality</th>
    <td>
    <select class="w100p" id="nation" name="nation">
        <option value="" selected>Select Account</option>
         <c:forEach var="list" items="${nationality }" varStatus="status">
           <option value="${list.countryid}">${list.name}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Race</th>
    <td>
    <select class="w100p" id="race" name="race">
        <option value="" selected>Select Account</option>
        <c:forEach var="list" items="${race }" varStatus="status">
           <option value="${list.detailcodeid}">${list.detailcodename}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Status</th>
    <td>
    <select class="w100p" id="status" name="status">
        <option value="" selected>Select Account</option>
        <c:forEach var="list" items="${status }" varStatus="status">
           <option value="${list.statuscodeid}">${list.name}</option>
        </c:forEach>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Contact No</th>
    <td>
    <input type="text" title="Contact No" placeholder="" class="w100p" id="contact" name="contact"/>
    </td>

    <%-- By KV start - Position Selection button --%>
    <th scope="row">Position</th>
    <td>
    <select class="w100p" id="position" name="position">
        <option value="" selected>Select Account</option>
        <c:forEach var="list" items="${position}" varStatus="status">
            <option value="${list.positionLevel}">${list.positionName}</option>
        </c:forEach>
    </select>
    </td>
    <%-- By KV end - Position Selection button --%>

    <th scope="row"></th>
    <td>
    </td>
    <th scope="row"></th>
    <td>
    </td>
</tr>
<tr>
    <th scope="row">Key-In User</th>
    <td>
    <select class="w100p" id="keyUser" name="keyUser">
        <option value="" selected>Select Account</option>
        <c:forEach var="list" items="${user }" varStatus="status">
           <option value="${list.userid}">${list.username}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Key-In User Branch</th>
    <td>
    <select class="w100p" id="keyBranch" name="keyBranch">
    <option value="" selected>Select Account</option>
        <c:forEach var="list" items="${userBranch }" varStatus="status">
           <option value="${list.branchid}">${list.c1}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row">Key-In Date</th>
    <td colspan="3">

    <div class="date_set"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="createDate" name="createDate" /></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date"  id="endDate" name="endDate"/></p>
    </div><!-- date_set end -->

    </td>
</tr>
</tbody>
</table><!-- table end -->


</form>
</section><!-- search_table end -->

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
    <div id="grid_wrap_memList" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

<aside class="bottom_msg_box"><!-- bottom_msg_box start -->
<p>Information Message Area</p>
</aside><!-- bottom_msg_box end -->

</section><!-- container end -->

</div><!-- wrap end -->
