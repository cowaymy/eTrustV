<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
$(document).ready(function(){
    // AUIGrid 그리드를 생성합니다.
    createAUIGrid();

    //Search
    $("#_searchBtn").click(function() {
        if(FormUtil.checkReqValue($('#icNum')) &&
       		FormUtil.checkReqValue($('#orgToJoin option:selected')) &&
       		FormUtil.checkReqValue($('#approvalStatus option:selected')) &&
       		FormUtil.checkReqValue($('#code')) &&
       		FormUtil.checkReqValue($('#approvedBy')) &&
       		FormUtil.checkReqValue($('#name')) &&
       		FormUtil.checkReqValue($('#currentStatus')) ){
            Common.alert("* Please Key in at least one of the NRIC, Sales Org to Join, Approval Status, Member Code, Approval By, Member Name or Current Status");
        }else{
        	fn_memberEligibilitySearch();
        }
    });

    AUIGrid.bind(myGridID, "cellClick", function(event) {
       memberid =  event.item.memId;
       memberName = event.item.name;
       memberCode = event.item.memCode;
       nric = event.item.nric;
       approveStatusId = event.item.apprStus;
   });
});

function createAUIGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "memId",
        headerText : "Member ID",
        editable : false,
        visible: false
    },{
        dataField : "name",
        headerText : "Member Name",
        editable : false,
    }, {
        dataField : "memCode",
        headerText : "Member Code",
        editable : false,
    }, {
        dataField : "nric",
        headerText : "IC Number",
        editable : false
    },{
        dataField : "statusName",
        headerText : "Current Status",
        editable : false,
        labelFunction : function(rowIndex, columnIndex, value, headerText, item, dataField, cItem) {
        	   // logic processing
        	   // Return value here, reprocessed or formatted as desired.
        	   // The return value of the function is immediately printed in the cell.
        	    if(item.trmRejoin == 1) {
                       return item.statusName + " (Rejoin)";
                  } else {
                       return item.statusName;
                  }
        	}
    },{
        dataField : "salOrgRejoin",
        headerText : "Sales Org to Join",
        editable : false
    }, {
        dataField : "apprStusName",
        headerText : "Approval Status",
        editable : false
    }, {
        dataField : "approvedBy",
        headerText : "Approved by",
        editable : false
    }];

     // 그리드 속성 설정
    var gridPros = {
             usePaging           : true,         //페이징 사용
             pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)
             editable            : false,
             fixedColumnCount    : 1,
             showStateColumn     : false,
             displayTreeOpen     : true,
            // selectionMode       : "singleRow",  //"multipleCells",
             headerHeight        : 30,
             useGroupingPanel    : false,        //그룹핑 패널 사용
             skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
             wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
             showRowNumColumn    : true       //줄번호 칼럼 렌더러 출력
    };

    myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
}

// 리스트 조회.
function fn_memberEligibilitySearch() {
    Common.ajax("GET", "/organization/memberEligibilitySearch", $("#searchForm").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}

function fn_memberRejoinPop(){
	if((typeof memberid) === 'undefined'){
		Common.alert("Please select a member to rejoin");
	} else {
	    var data = {
	    		memberID : memberid,
	    		approveStatusId : approveStatusId
	    }

	    Common.ajax("GET", "/organization/memberRejoinCheck.do", data, function(result) {
	       	if(result.code != "pass"){
	       		Common.alert(result.message);
	       	} else {
	       		// Allow member to rejoin
	       		Common.confirm(result.message, function(){
	       			var selectedData = {
		       			   memberID : memberid,
		       			   memberName : memberName,
			       	       memberCode : memberCode,
			       	       nric : nric
	       			}

	                Common.popupDiv("/organization/memberRejoinPop.do", selectedData, null, true,'popup_wrap_selectOrgToRejoin');
	       		});
	       	}
	    });
	}
}
</script>

<section id="content"><!-- content start -->
	<ul class="path">
	    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
	    <li>Organization</li>
	    <li>Member</li>
	    <li>Member Eligibility</li>
	</ul>

	<aside class="title_line"><!-- title_line start -->
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2>Member Eligibility</h2>
		<ul class="right_btns">
            <li><p class="btn_blue"><a href="#" id="_searchBtn"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
            <li><p class="btn_blue"><a href="javascript:fn_memberRejoinPop()">Rejoin</a></p></li>
		</ul>
	</aside><!-- title_line end -->

	<section class="search_table"><!-- search_table start -->
		<form action="#" id="searchForm" name="searchForm" method="post">
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
				    <col style="width:140px" />
				    <col style="width:*" />
				    <col style="width:150px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
					    <th scope="row">NRIC</th>
					    <td><input type="text" title="IC Number" placeholder="NRIC" class="w100p" id="icNum" name="icNum" /></td>
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
					    <th scope="row">Member Code</th>
					    <td>
					        <input type="text" title="Code" placeholder="" class="w100p" id="code" name="code" />
					    </td>
					    <th scope="row">Approval By</th>
					    <td>
					        <input type="text" title="Approval By" placeholder="" class="w100p" id="approvedBy" name="approvedBy"/>
					    </td>
					</tr>
					<tr>
					    <th scope="row">Member Name</th>
					    <td>
					       <input type="text" title="Name" placeholder="" class="w100p" id="name" name="name" />
					    </td>
				        <th scope="row">Current Status</th>
				        <td>
			                <select class="w100p" id="currentStatus" name="currentStatus">
                                <option value="" selected>Choose One</option>
                                <option value="1">Active</option>
                                <option value="3">Terminated</option>
                                   <option value="51">Resigned</option>
                                   <option value="Rejoin">Rejoin</option>
                            </select>
			            </td>
					</tr>
				</tbody>
			</table><!-- table end -->
		</form>
	</section><!-- search_table end -->

	<section class="search_result"><!-- search_result start -->
		<article class="grid_wrap"><!-- grid_wrap start -->
		    <div id="grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
		</article><!-- grid_wrap end -->
	</section><!-- search_result end -->
</section><!-- content end -->