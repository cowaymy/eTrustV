<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

    <script type="text/javaScript">

    function fn_excelDown(){
        // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
        GridCommon.exportTo("grid_wrap", "xlsx", "Member Event Search");
    }

    function fn_confirmPopup(){
    	 if(stusId == 60){//in progress 일때만 confirm event open
//           fn_setDetail(myGridID, event.rowIndex);
    		 Common.popupDiv("/organization/getMemberEventDetailPop.do?isPop=true&promoId=" + promoId, "");
           }else{
               Common.alert("Only event [In Progress] status is allowed.");
           }
    }

 // AUIGrid 생성 후 반환 ID
    var myGridID;

    var gridValue;

    var option = {
        width : "1000px", // 창 가로 크기
        height : "600px" // 창 세로 크기
    };


// 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
    $(document).ready(function(){

	    // AUIGrid 그리드를 생성합니다.
	    createAUIGrid();

	    AUIGrid.setSelectionMode(myGridID, "singleRow");


	    AUIGrid.bind(myGridID, "cellClick", function(event) {
	        //alert(event.rowIndex+ " -cellClick : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid"));
	        promoId =  AUIGrid.getCellValue(myGridID, event.rowIndex, "promoId");
	        stusId = AUIGrid.getCellValue(myGridID, event.rowIndex, "stusId");

	        //Common.popupDiv("/organization/requestTerminateResign.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype"), "");
	    });

	    // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {

        	//alert(AUIGrid.getCellValue(myGridID, event.rowIndex, "promoId"));
        	Common.popupDiv("/organization/getMemberEventViewPop.do?isPop=true&promoId=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "promoId"), "");

        });

    });


/*     // 컬럼 선택시 상세정보 세팅.
    function fn_setDetail(gridID, rowIdx){
        alert("aaaaaaaaaa");
        Common.popupWin("searchForm", "/organization/getMemberEventDetailPop.do?isPop=true&promoId=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "promoId"), option);
    } */



    function createAUIGrid(){
        // AUIGrid 칼럼 설정
	    var columnLayout = [ 
	                        {
                                dataField : "memberid",
                                headerText : "memberid",
                                width:0
                               
                               
                           }, {
                                 dataField : "branchid",
                                 headerText : "branchid",
                                 width:0
                                
                                
                            },{
	                        	 dataField : "eventdt",
	                             headerText : "eventdt",
	                             width:0
	                        	
	                        	
	                        },
	                   {
                           dataField : "checkFlag",
                            headerText : ' ',
                             width: 20,
                           renderer : {
                                             type : "CheckBoxEditRenderer",
                                               showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                               editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                               checkValue : "1", // true, false 인 경우가 기본
                                               unCheckValue : "0"
                                           }
                       },{
                    dataField : "promoId",
                    headerText : "promo ID.",
                    width : 120,
                    visible:false     
                }, {
	                dataField : "reqstNo",
	                headerText : "Request No.",
	                width : 120
	            }, {
	                dataField : "typeDesc",
	                headerText : "Req Type",
	                width : 120
	            }, {
	                dataField : "code",
	                headerText : "Member Type",
	                width : 120
	            }, {
	                dataField : "memCode",
	                headerText : "Member Code.",
	                width : 120
	            }, {
	                dataField : "name",
	                headerText : "Member Name.",
	                width : 120
	            }, {
	                dataField : "c1",
	                headerText : "Level (From)",
	                width : 120
	            }, {
	                dataField : "c2",
	                headerText : "Level (To)",
	                width : 120
	            }, {
	                dataField : "name1",
	                headerText : "Status",
	                width : 120
	            }, {
	                dataField : "userName",
	                headerText : "ReqBy",
	                width : 120
	            }, {
	                dataField : "crtDt",
	                headerText : "ReqAt",
	                width : 120
	            }, {
                    dataField : "stusId",
                    headerText : "",
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
		        myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
    }


// 리스트 조회.
function fn_getOrgEventListAjax() {
    Common.ajax("GET", "/organization/selectMemberEventList", $("#searchForm").serialize(), function(result) {

        console.log("성공.");
        console.log("data : " + result);
        AUIGrid.setGridData(myGridID, result);
    });
}
function fn_failOrgEventsAjax(){
    var activeItems = AUIGrid.getItemsByValue(myGridID, "checkFlag", "1");
     console.log(activeItems);
  
 
    Common.confirm("Do you want to cancel the Events?"  , fn_MemsFail );
 
}
function fn_MemsFail(){
 var activeItems = AUIGrid.getItemsByValue(myGridID, "checkFlag", "1");
 console.log(activeItems);

 
 var jasonObj={update : activeItems};
 console.log(jasonObj);
    Common.ajax("POST", "/organization/updateMemberListFail", jasonObj, function(result) {

         console.log("성공.");
         console.log("data : " + result);
         Common.alert(result.message);
         
   
     });
}


function fn_getOrgEventsAjax(){
	   var activeItems = AUIGrid.getItemsByValue(myGridID, "checkFlag", "1");
	    console.log(activeItems);
	 
	
	   Common.confirm("Do you want to approve the Events?"  , fn_MemsApprove );
	
}
function fn_MemsApprove(){
	var activeItems = AUIGrid.getItemsByValue(myGridID, "checkFlag", "1");
	console.log(activeItems);

	
	var jasonObj={update : activeItems};
	console.log(jasonObj);
	   Common.ajax("POST", "/organization/updateMemberListApprove", jasonObj, function(result) {

	        console.log("성공.");
	        console.log("data : " + result);
	        Common.alert(result.message);
	        
	  
	    });
	
}

// 그리드 초기화.
function resetUpdatedItems() {
     AUIGrid.resetUpdatedItems(myGridID, "a");
 }


function f_info(data , v){


}



    function f_multiCombo(){
        $(function() {
            $('#requestStatus').change(function() {

            }).multipleSelect({
                selectAll: true, // 전체선택
                width: '80%'
            });
            $('#requestType').change(function() {

            }).multipleSelect({
                selectAll: true,
                width: '80%'
            });
             $('#memberType').change(function() {

            }).multipleSelect({
                selectAll: true,
                width: '80%'
            });
        });
    }

//    doGetCombo('/common/selectCodeList.do', '165', '','requestStatus', 'M' , 'f_multiCombo'); // Request Status
//    doGetCombo('/common/selectCodeList.do', '18', '','requestPerson', 'M' , 'f_multiCombo'); //Request Person
    //doGetCombo('/common/selectCodeList.do', '18', '','requestType', 'M' , 'f_multiCombo'); //Request Type
    //doGetCombo('/common/selectCodeList.do', '1', '','memberType', 'M' , 'f_multiCombo'); //MemberType

</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>Member Event</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Member Event Search</h2>
<ul class="right_btns">
     <li><p class="btn_blue"><a href="#" onclick="javascript:fn_getOrgEventsAjax();">Complete Members Event</a></p></li>
     <li><p class="btn_blue"><a href="#" onclick="javascript:fn_failOrgEventsAjax();">Cancel Members Event</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_getOrgEventListAjax();"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" id= "searchForm"' method="post">

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
    <th scope="row">Request No(From)</th>
    <td>
    <input id ="requestNoF" name="requestNoF" type="text" title="Request No(From)" placeholder="" class="w100p" />
    </td>
    <th scope="row">Request No(To)</th>
    <td>
    <input  id ="requestNoT" name="requestNoT" type="text" title="Request No(To)" placeholder="" class="w100p" />
    </td>
    <th scope="row">Request Date(From)</th>
    <td>
    <input id ="requestDateF" name="requestDateF" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
    </td>
    <th scope="row">Request Date(To)</th>
    <td>
    <input id ="requestDateT" name="requestDateT" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
    </td>
</tr>
<tr>
    <th scope="row">Request Status</th>
    <td>
    <select id="requestStatus" name="requestStatus" class="multy_select w100p" multiple="multiple">
         <option value="60">In Progress</option>
         <option value="04">Completed</option>
         <option value="10">Cancelled</option>
    </select>
    </td>
    <th scope="row">Request Type</th>
    <td>
    <select  id="requestType" name="requestType" class="multy_select w100p" multiple="multiple">
        <option value="747">Promote</option>
        <option value="748">Demote</option>
        <option value="749">Transfer</option>
        <option value="757">Terminate</option>
        <option value="758">Resign</option>
        <!--By KV - add 1 type request Type  -->
        <option value="2740">Vacation</option>


     </select>
    </td>
    <th scope="row">Request Person</th>
    <td>
    <select  id="requestPerson" name="requestPerson" class="w100p">
        <option value="" selected>Person</option>
            <c:forEach var="list" items="${ reqPersonComboList}" varStatus="status">
                 <option value="${list.userName}">${list.userName } </option>
            </c:forEach>
    </select>
    </td>
    <th scope="row"></th>
    <td>
    </td>
</tr>
<tr>
    <th scope="row">Member Type</th>
    <td>
    <select id="memberType" name="memberType"  class="multy_select w100p" multiple="multiple">
         <option value="1">Health Planner</option>
         <option value="2">Coway Lady</option>
         <option value="3">Coway Technician</option>
    </select>
    </td>
    <th scope="row">Member Code</th>
    <td>
    <input id ="memberCode" name="memberCode" type="text" title="Member Code" placeholder="" class="w100p" />
    </td>
    <th scope="row"></th>
    <td>
    </td>
    <th scope="row"></th>
    <td>
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
        <li><p class="link_btn"><a href="#" onclick="javascript:fn_confirmPopup();">Confirm Member Event</a></p></li>
       
        <!-- <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li> -->
    </ul>
    <ul class="btns">
       <!--  <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
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
    <li><p class="btn_grid"><a href="#" onClick="javascript:fn_excelDown()">EXCEL DW</a></p></li>
   <!--  <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li> -->
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" style="width:100%; height:500px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->