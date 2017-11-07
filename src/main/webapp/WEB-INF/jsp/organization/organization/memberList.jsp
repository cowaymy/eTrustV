<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var myGridID;
var grpOrgList = new Array(); // Group Organization List
var orgList = new Array(); // Organization List

function fn_memberListNew(){
	 Common.popupDiv("/organization/selectMemberListNewPop.do?isPop=true", "searchForm");
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
	if(val == '1'){
		 var jsonObj = {
				     MemberID :memberid,
		            MemberType : memberType
		    };
		console.log("MemberID="+memberid+"&MemberType="+memberType+"&codeValue=1");
		Common.popupDiv("/organization/requestTerminateResign.do?isPop=true&MemberID="+memberid+"&MemberType="+memberType+"&codeValue=1",'');
	}else{
		 var jsonObj = {
                 MemberID :memberid,
                MemberType : memberType
        };
		 console.log("MemberID="+memberid+"&MemberType="+memberType+"&codeValue=2");
    Common.popupDiv("/organization/requestTerminateResign.do?isPop=true&MemberID="+memberid+"&MemberType="+memberType+"&codeValue=2",'');
	}
}


//Start AUIGrid
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
    	//Common.popupDiv("/organization/requestTerminateResign.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype"), "");
    }); 
     
});

function createAUIGrid() {
		//AUIGrid 칼럼 설정
		var columnLayout = [ {
		    dataField : "codename",
		    headerText : "Type Name",
		    editable : false,
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
		    dataField : "name1",
		    headerText : "Status",
		    editable : false,
		    width : 130
		}, {
		    dataField : "updated",
		    headerText : "Last Update",
		    editable : false,
		    width : 130
		    
		}, {
            dataField : "membertype",
            headerText : "Member Type",
            width : 0
		}];
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
                 showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    

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
	     Common.popupDiv("/organization/memberListEditPop.do?isPop=true", "searchForm");
}
</script>


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
    <li><p class="btn_blue"><a href="javascript:fn_memberListNew();">New</a></p></li>
    <li><p class="btn_blue"><a href="javascript:fn_memberListSearch();"><span class="search"></span>Search</a></p></li>
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
    <select class="w100p" id="memTypeCom" name="memTypeCom">
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
    <th scope="row"></th>
    <td>
    </td>
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

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="javascript:fn_TerminateResign('1')">Request Terminate/Resign</a></p></li>
        <li><p class="link_btn"><a href="javascript:fn_TerminateResign('2')">Request Promote/Demote</a></p></li>
        <li><p class="link_btn"><a href="javascript:fn_memberEditPop()">Member Edit</a></p></li>
        <li><p class="link_btn"><a href="#" onclick="Common.alert('The program is under development')">Request Vacation </a></p></li>
<!--         <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li> -->
    </ul>
    <ul class="btns">
        <!-- <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li> -->
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
<li><p class="btn_grid"><a href="javascript:fn_excelDown();">EXCEL DW</a></p></li>
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
