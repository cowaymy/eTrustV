<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
	var addrGridID;      // addrlist
	var contactGridID; // contact list
	
	$(document).ready(function(){
		fn_getAddrListAjax(); // address list
		fn_getContactListAjax(); // contact list
		
		createCntGrid();
		createAddrGrid();
		
	});
	
	function createAddrGrid(){
		
		// 데이터 형태는 다음과 같은 형태임,
        var columnLayout = [ {
                dataField : "code",
                headerText : '<spring:message code="sal.title.status" />',
                width : 140,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "fullAddr",
                headerText : '<spring:message code="sal.text.fullAddr" />',
                editable : false,
                style: 'left_style'
            },{
                dataField : "undefined",
                headerText : '<spring:message code="sal.title.text.view" />',
                width : 140,
                renderer : {
                      type : "ButtonRenderer",
                      labelText : "View",
                      onclick : function(rowIndex, columnIndex, value, item) {
                          $("#dealerId").val(item.dealerId);
                          $("#pstDealerDelvryAddId").val(item.dealerAddId);
                        	  Common.popupDiv("/sales/pst/pstDealerAddrViewPop.do", $("#viewForm").serializeJSON(), null , true , 'vPopDiv');
                          }
                      }
               }];

     // 그리드 속성 설정
        var gridPros = {
            
            // 페이징 사용       
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 10,
            editable : true,
            fixedColumnCount : 1,
            showStateColumn : false, 
            displayTreeOpen : true,
            selectionMode : "multipleCells",
            headerHeight : 30,
            // 그룹핑 패널 사용
            useGroupingPanel : false,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true,
        
            groupingMessage : "Here groupping"
        };
        
        addrGridID = AUIGrid.create("#addr_grid_wrap", columnLayout, gridPros);
    }
	
function createCntGrid(){
        
        // 데이터 형태는 다음과 같은 형태임,
        var columnLayout = [ {
                dataField : "stusCode",
                headerText : '<spring:message code="sal.title.status" />',
                width : 80,
                editable : false,
                style: 'left_style'
            },{
                dataField : "cntName",
                headerText : '<spring:message code="sal.title.text.contactName" />',
                editable : false,
                style: 'left_style'
            },{
                dataField : "telM1",
                headerText : '<spring:message code="sal.title.text.telMOne" />',
                width : 110,
                editable : false,
                style: 'left_style'
            },{
                dataField : "telM2",
                headerText : '<spring:message code="sal.title.text.telMTwo" />',
                width : 110,
                editable : false,
                style: 'left_style'
            },{
                dataField : "telO",
                headerText : '<spring:message code="sal.text.telO" />',
                width : 110,
                editable : false,
                style: 'left_style'
            },{
                dataField : "telR",
                headerText : '<spring:message code="sal.text.telR" />',
                width : 110,
                editable : false,
                style: 'left_style'
            },{
                dataField : "telf",
                headerText : '<spring:message code="sal.text.telF" />',
                width : 110,
                editable : false,
                style: 'left_style'
            },{
                dataField : "undefined",
                headerText : "View",
                width : 140,
                renderer : {
                      type : "ButtonRenderer",
                      labelText : "View",
                      onclick : function(rowIndex, columnIndex, value, item) {
                          $("#pstDealerMailCntId").val(item.dealerCntId);
                              Common.popupDiv("/sales/pst/pstDealerCntViewPop.do", $("#viewForm").serializeJSON(), null , true , 'vPopDiv');
                          }
                      }
               }];

     // 그리드 속성 설정
        var gridPros = {
            
            // 페이징 사용       
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 10,
            editable : true,
            fixedColumnCount : 1,
            showStateColumn : false, 
            displayTreeOpen : true,
            selectionMode : "multipleCells",
            headerHeight : 30,
            // 그룹핑 패널 사용
            useGroupingPanel : true,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true,
        
            groupingMessage : "Here groupping"
        };
        
        contactGridID = AUIGrid.create("#cnt_grid_wrap", columnLayout, gridPros);
    }
	
	function fn_getAddrListAjax(){
		Common.ajax("GET", "/sales/pst/pstDealerAddrJsonList", $("#viewForm").serialize(), function(result) {
            AUIGrid.setGridData(addrGridID, result);
        }
        );
	}
	
	function fn_getContactListAjax(){
        Common.ajax("GET", "/sales/pst/pstDealerCntJsonList", $("#viewForm").serialize(), function(result) {
            AUIGrid.setGridData(contactGridID, result);
        }
        );
    }
	
	function fn_goDealerEdit(){
		fn_pstDealerListAjax();
        Common.popupDiv('/sales/pst/getPstDealerEditPop.do', $('#viewForm').serializeJSON(), null , true, '_editDiv11');
        $("#autoClose").click();
    }
	
	//resize func (tab click)
    function fn_resizefunc(gridName){
        AUIGrid.resize(gridName, 950, 300);
   }

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.viewPstDealerInfo" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="autoClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<ul class="right_btns" id="editBtn">
    <li><p class="btn_blue2"><a href="#" onclick="javascript: fn_goDealerEdit()"><spring:message code="sal.title.text.edit" /></a></p></li>
</ul>
<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on"><spring:message code="sal.tap.title.basicInfo" /></a></li>
    <li><a href="#" onclick="javascript: fn_resizefunc(addrGridID)"><spring:message code="sal.tap.title.mainAddr" /></a></li>
    <li><a href="#" onclick="javascript: fn_resizefunc(contactGridID)"><spring:message code="sal.tap.title.mainContact" /></a></li>
    <li><a href="#"><spring:message code="sal.title.text.userInfo" /></a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->
<form id="viewForm" name="viewForm" method="POST">
    <input type="hidden" id="dealerId" name="dealerId" value="${dealerId }">
    <!-- dealer add id -->
    <input type="hidden" id="pstDealerDelvryAddId" name="pstDealerDelvryAddId">
    <!-- dealer cnt id -->
    <input type="hidden" id="pstDealerMailCntId" name="pstDealerMailCntId">
</form>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.dealerName" /></th>
    <td><span>${pstDealerBasicInfo.dealerName }</span></td>
    <th scope="row"><spring:message code="sal.title.text.dealerType" /></th>
    <td><span>${pstDealerBasicInfo.codeName }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.email" /></th>
    <td colspan="3"><span>${pstDealerBasicInfo.dealerEmail }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.nricCompNo" /></th>
    <td><span>${pstDealerBasicInfo.dealerNric }</span></td>
    <th scope="row"><spring:message code="sal.text.branch" /></th>
    <td><span>${pstDealerDtUserInfo.c3 }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.creator" /></th>
    <td><span>${pstDealerBasicInfo.crtUserName }</span></td>
    <th scope="row"><spring:message code="sal.title.created" /></th>
    <td><span>${pstDealerBasicInfo.crtDt }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.updator" /></th>
    <td><span>${pstDealerBasicInfo.updUserName }</span></td>
    <th scope="row"><spring:message code="sal.text.updated" /></th>
    <td><span>${pstDealerBasicInfo.updDt }</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.fullAddr" /></th>
    <td colspan="3"><span>${dealerAddrTop.fullAddr}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.remark" /></th>
    <td colspan="3"><span>${dealerAddrTop.rem}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.creator" /></th>
    <td><span>${dealerAddrTop.crtUserName}</span></td>
    <th scope="row"><spring:message code="sal.title.created" /></th>
    <td><span>${dealerAddrTop.crtDt}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.updator" /></th>
    <td><span>${dealerAddrTop.updUserName}</span></td>
    <th scope="row"><spring:message code="sal.text.updated" /></th>
    <td><span>${dealerAddrTop.updDt}</span></td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="addr_grid_wrap" style="width:100%; height:280px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.name" /></th>
    <td><span>${dealerCntTop.cntName}</span></td>
    <th scope="row"><spring:message code="sal.text.initial" /></th>
    <td><span>${dealerCntTop.dealerInitialCode}</span></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><span>${dealerCntTop.gender}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nric" /></th>
    <td><span>${dealerCntTop.nric}</span></td>
    <th scope="row"><spring:message code="sal.text.race" /></th>
    <td><span>${dealerCntTop.raceName}</span></td>
    <th scope="row"><spring:message code="sal.title.text.telMobile1" /></th>
    <td><span>${dealerCntTop.telM1}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telMobile2" /></th>
    <td><span>${dealerCntTop.telM2}</span></td>
    <th scope="row"><spring:message code="sal.text.telO" /></th>
    <td><span>${dealerCntTop.telO}</span></td>
    <th scope="row"><spring:message code="sal.text.telR" /></th>
    <td><span>${dealerCntTop.telR}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telF" /></th>
    <td><span>${dealerCntTop.telf}</span></td>
    <th scope="row"><spring:message code="sal.title.creator" /></th>
    <td><span>${dealerCntTop.crtUserName}</span></td>
    <th scope="row"><spring:message code="sal.title.created" /></th>
    <td><span>${dealerCntTop.crtDt}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.updator" /></th>
    <td><span>${dealerCntTop.updUserName}</span></td>
    <th scope="row"><spring:message code="sal.text.updated" /></th>
    <td><span>${dealerCntTop.updDt}</span></td>
    <th scope="row"></th>
    <td><span><spring:message code="sal.title.text.text" /></span></td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="cnt_grid_wrap" style="width:100%; height:280px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.userName" /></th>
    <td><span>${pstDealerDtUserInfo.userName}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.fullName" /></th>
    <td><span>${pstDealerDtUserInfo.userFullName}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.joinDate" /></th>
    <td><span>${pstDealerDtUserInfo.userDtJoin}</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->