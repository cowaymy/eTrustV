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
                headerText : "Status",
                width : 140,
                editable : false,
                style: 'left_style'
            }, {
                dataField : "fullAddr",
                headerText : "Full Address",
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
                headerText : "Status",
                width : 80,
                editable : false,
                style: 'left_style'
            },{
                dataField : "cntName",
                headerText : "Contact Name",
                editable : false,
                style: 'left_style'
            },{
                dataField : "telM1",
                headerText : "Tel(Mobile1)",
                width : 110,
                editable : false,
                style: 'left_style'
            },{
                dataField : "telM2",
                headerText : "Tel(Mobile2)",
                width : 110,
                editable : false,
                style: 'left_style'
            },{
                dataField : "telO",
                headerText : "Tel(Office)",
                width : 110,
                editable : false,
                style: 'left_style'
            },{
                dataField : "telR",
                headerText : "Tel(Residence)",
                width : 110,
                editable : false,
                style: 'left_style'
            },{
                dataField : "telf",
                headerText : "Tel(Fax)",
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
<h1>VIEW PST DEALER INFO</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="autoClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<ul class="right_btns" id="editBtn">
    <li><p class="btn_blue2"><a href="#" onclick="javascript: fn_goDealerEdit()">EDIT</a></p></li>
</ul>
<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Basic Info</a></li>
    <li><a href="#" onclick="javascript: fn_resizefunc(addrGridID)">Main Address</a></li>
    <li><a href="#" onclick="javascript: fn_resizefunc(contactGridID)">Main Contact</a></li>
    <li><a href="#">User Info</a></li>
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
    <th scope="row">Dealer Name</th>
    <td><span>${pstDealerBasicInfo.dealerName }</span></td>
    <th scope="row">Dealer Type</th>
    <td><span>${pstDealerBasicInfo.codeName }</span></td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td colspan="3"><span>${pstDealerBasicInfo.dealerEmail }</span></td>
</tr>
<tr>
    <th scope="row">NRIC/CompanyNo</th>
    <td><span>${pstDealerBasicInfo.dealerNric }</span></td>
    <th scope="row">Branch</th>
    <td><span>${pstDealerBasicInfo.dealerName }</span></td>
</tr>
<tr>
    <th scope="row">Creator</th>
    <td><span>${pstDealerBasicInfo.crtUserName }</span></td>
    <th scope="row">Created</th>
    <td><span>${pstDealerBasicInfo.crtDt }</span></td>
</tr>
<tr>
    <th scope="row">Updator</th>
    <td><span>${pstDealerBasicInfo.updUserName }</span></td>
    <th scope="row">Updated</th>
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
    <th scope="row">Full Address</th>
    <td colspan="3"><span>${dealerAddrTop.fullAddr}</span></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><span>${dealerAddrTop.rem}</span></td>
</tr>
<tr>
    <th scope="row">Creator</th>
    <td><span>${dealerAddrTop.crtUserName}</span></td>
    <th scope="row">Created</th>
    <td><span>${dealerAddrTop.crtDt}</span></td>
</tr>
<tr>
    <th scope="row">Updator</th>
    <td><span>${dealerAddrTop.updUserName}</span></td>
    <th scope="row">Udpated</th>
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
    <th scope="row">Name</th>
    <td><span>${dealerCntTop.cntName}</span></td>
    <th scope="row">Initial</th>
    <td><span>${dealerCntTop.dealerInitialCode}</span></td>
    <th scope="row">Gender</th>
    <td><span>${dealerCntTop.gender}</span></td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td><span>${dealerCntTop.nric}</span></td>
    <th scope="row">Race</th>
    <td><span>${dealerCntTop.raceName}</span></td>
    <th scope="row">Tel (Mobile 1)</th>
    <td><span>${dealerCntTop.telM1}</span></td>
</tr>
<tr>
    <th scope="row">Tel (Mobile 2)</th>
    <td><span>${dealerCntTop.telM2}</span></td>
    <th scope="row">Tel (Office)</th>
    <td><span>${dealerCntTop.telO}</span></td>
    <th scope="row">Tel (Residence)</th>
    <td><span>${dealerCntTop.telR}</span></td>
</tr>
<tr>
    <th scope="row">Tel (Fax)</th>
    <td><span>${dealerCntTop.telf}</span></td>
    <th scope="row">Creator</th>
    <td><span>${dealerCntTop.crtUserName}</span></td>
    <th scope="row">Created</th>
    <td><span>${dealerCntTop.crtDt}</span></td>
</tr>
<tr>
    <th scope="row">Updator</th>
    <td><span>${dealerCntTop.updUserName}</span></td>
    <th scope="row">Updated</th>
    <td><span>${dealerCntTop.updDt}</span></td>
    <th scope="row"></th>
    <td><span>text</span></td>
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
    <th scope="row">Username</th>
    <td><span>${pstDealerDtUserInfo.userName}</span></td>
</tr>
<tr>
    <th scope="row">Full Name</th>
    <td><span>${pstDealerDtUserInfo.userFullName}</span></td>
</tr>
<tr>
    <th scope="row">Join Date</th>
    <td><span>${pstDealerDtUserInfo.userDtJoin}</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->