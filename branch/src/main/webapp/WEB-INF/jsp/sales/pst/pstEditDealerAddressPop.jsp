<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
	//AUIGrid 생성 후 반환 ID
	var addrGridID;
	
	$(document).ready(function(){
	    
	    // AUIGrid 그리드를 생성합니다.
	    createEditAUIGrid();
	
	    //Call Ajax
	    fn_getAddrListAjax();
	    
	    // 셀 더블클릭 이벤트 바인딩 - 주소수정
	    AUIGrid.bind(addrGridID, "cellDoubleClick", function(event){
	        $("#_editDealerId").val(event.item.dealerId);
	        $("#_editDealerAddId").val(event.item.dealerAddId);
	        Common.popupDiv('/sales/pst/pstUpdAddrPop.do', $("#editForm").serializeJSON(), null , true ,'_editDiv2Pop');
	    });
//	    doGetCombo('/sales/pst/getInchargeList', '', $("#editInchargeSelect").val(),'editIncharge', 'S' , ''); //Incharge Person
	});
	
	function createEditAUIGrid() {
	    // AUIGrid 칼럼 설정
	    
	    // 데이터 형태는 다음과 같은 형태임,
	    //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
	    var columnLayout = [{
	            dataField : "code",
	            headerText : '<spring:message code="sal.title.status" />',
	            width : 120,
	            editable : false
	        }, {
	            dataField : "fullAddr",
	            headerText : '<spring:message code="sal.text.fullAddr" />',
	            editable : false
	        }, {
	        	dataField : "setMain", 
	            headerText : '<spring:message code="sal.title.setAsMain" />', 
	            width:'10%', 
	            renderer : { 
	                type : "TemplateRenderer", 
	                editable : true // 체크박스 편집 활성화 여부(기본값 : false)
	            }, 
	            // dataField 로 정의된 필드 값이 HTML 이라면 labelFunction 으로 처리할 필요 없음. 
	            labelFunction : function (rowIndex, columnIndex, value, headerText, item ) { // HTML 템플릿 작성 
	                var html = '';
	            
	                html += '<label><input type="radio" name="setmain"  onclick="javascript: fn_setMain(' + item.dealerAddId + ','+item.dealerId+')"';
	                
	                if(item.stusCodeId == 9){
	                    html+= ' checked = "checked"';
	                    html+= ' disabled = "disabled"';
	                }
	                
	                html += '/></label>'; 
	                
	                return html;
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
	        showStateColumn : true, 
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
	    
	    addrGridID = GridCommon.createAUIGrid("#address_grid_wrap", columnLayout, gridPros);
	}
	
	function fn_getAddrListAjax(){
	    Common.ajax("GET", "/sales/pst/getAddrJsonListPop",$("#paramForm").serialize(), function(result) {
	        AUIGrid.setGridData(addrGridID, result);
	    });
	}
	
	// set Main Func (Confirm)
    function fn_setMain(dealerAddId, dealerId){ 
        $("#tempDealerId").val(dealerId);
        $("#tempDealerAddrId").val(dealerAddId);  
        Common.confirm('<spring:message code="sal.confirm.msg.confirmMainAddress" />', fn_changeMainAddr, fn_noConfirm);
        
    }
	
  //call Ajax(Set Main Address)
    function fn_changeMainAddr(){
        $("#_dealerId").val($("#tempDealerId").val());
        $("#_dealerAddId").val($("#tempDealerAddrId").val()); 

        Common.ajax("GET", "/sales/pst/updateDealerAddressSetMain.do", $("#popForm").serialize(), function(result){
            //result alert and reload
            //Common.alert(result.message, fn_reloadPage); //차후변경가능
            Common.alert(result.message);
            $("#_close").click();
            $("#autoClose").click();
            fn_selectPstRequestDOListAjax();
        });
    }
    
    function fn_reloadPage(){
        //Parent Window Method Call
        fn_selectPstRequestDOListAjax();
//        $("#_selectParam").val('2');
//        Common.popupDiv('/sales/pst/getPstRequestDODetailPop.do', $('#searchForm').serializeJSON(), null , true, '_editDiv2');
        Common.popupDiv('/sales/pst/getPstRequestDOEditPop.do', $('#getParamForm').serializeJSON(), null , true, '_editDiv2');
        $("#_close").click();
        $("#autoClose").click();
    }
    
    // main confirm => No
    function fn_noConfirm(){
        //Parent Window Method Call
        fn_selectPstRequestDOListAjax();

        $("#_close").click();
        $("#autoClose").click();
    }
	
    $("#_newAddr").click(function() {
        Common.popupDiv('/sales/pst/updateDealerNewAddressPop.do', $("#paramForm").serializeJSON(), null , true ,'_editDiv2New');
    });
    
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.editPstDealerAddress" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_close"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.dealerMainAddr" /></h2>
</aside><!-- title_line end -->

<form id="paramForm" name="paramForm" method="GET">
    <input type="hidden" id="dealerId" name="dealerId" value="${dealerId}">
    <input type="hidden" id="tempDealerId" name="tempDealerId">
    <input type="hidden" id="tempDealerAddrId" name="tempDealerAddrId">
</form>
<form id="editForm" method="post">
    <input type="hidden" name="dealerId"  id="_editDealerId"/>  <!-- Cust Id  -->
    <input type="hidden" name="editDealerAddId"   id="_editDealerAddId"/><!-- Address Id  -->
    <input type="hidden" name="custCntcId"   id="_custCntcId"> <!--Contact Id  -->
</form>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:100px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.fullAddr" /></th>
    <td><span>${pstMailAddr.fullAddr }</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.remark" /></th>
    <td><span>${pstMailAddr.rem }</span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.dealerAddrList" /></h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="_newAddr"><spring:message code="sal.btn.addNewAddr" /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="address_grid_wrap" style="width:100%; height:250px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->