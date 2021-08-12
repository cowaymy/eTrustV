<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
//AUIGrid 생성 후 반환 ID
 var contactGridID; // contact list
$(document).ready(function(){
    
    /*  Gird */
    //AUIGrid 그리드를 생성합니다. (address, contact , bank, creditcard, ownorder, thirdparty )
    createContactGrid();
    
    fn_getContactListAjax(); // contact list
    
     // 셀 더블클릭 이벤트 바인딩 - contact 수정
     AUIGrid.bind(contactGridID, "cellDoubleClick", function(event){
    	 $("#_editDealerId").val(event.item.dealerId);
         $("#_editDealerCntId").val(event.item.dealerCntId);
         $("#requestdo").val('R');
         Common.popupDiv("/sales/pst/dealerEditCntUpdPop.do", $("#contForm").serializeJSON(), null , true, '_editDiv3Pop');
     });
    
    
    $("#_newContact").click(function() {
        
        Common.popupDiv('/sales/pst/updateDealerNewContactPop.do', $("#contForm").serializeJSON(), null , true ,'_editDiv3New');
    });
});// Document Ready End


    function createContactGrid(){
    
         // Contact Column
        var contactColumnLayout= [ 
              {dataField : "stusCode", headerText : '<spring:message code="sal.title.status" />', width : '10%'},
              {dataField : "cntName", headerText : '<spring:message code="sal.text.name" />', width : '35%'},
              {dataField : "telM1", headerText : '<spring:message code="sal.text.telM" />', width : '10%'},
              {dataField : "telO", headerText : '<spring:message code="sal.text.telO" />',width : '10%'},
              {dataField : "telR", headerText : '<spring:message code="sal.text.telR" />', width : '10%' },
              {dataField : "telf",headerText : '<spring:message code="sal.text.telF" />',width : '10%'},
              {dataField : "dealerCntId", visible: false },
              {dataField : "dealerId", visible : false},
              { 
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
                  
                      html += '<label><input type="radio" name="setmain"  onclick="javascript: fn_setMain(' + item.dealerCntId + ','+item.dealerId+')"';
                      
                      if(item.stusCodeId == 9){
                          html+= ' checked = "checked"';
                          html+= ' disabled = "disabled"';
                      }
                      
                      html += '/></label>'; 
                      
                      return html;
                  } 
                  
                }];
         
      //그리드 속성 설정
        var gridPros = {
                
                usePaging           : true,         //페이징 사용
                pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
                editable            : false,            
                fixedColumnCount    : 1,            
                showStateColumn     : true,             
                displayTreeOpen     : false,            
//                selectionMode       : "singleRow",  //"multipleCells",            
                headerHeight        : 30,       
                useGroupingPanel    : false,        //그룹핑 패널 사용
                skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
                noDataMessage       : "No order found.",
                groupingMessage     : "Here groupping"
            };
        
         contactGridID = GridCommon.createAUIGrid("#contact_grid_wrap", contactColumnLayout,'',gridPros); // contact list
            
    }

    //Get Contact by Ajax
    function fn_getContactListAjax(){
        Common.ajax("GET", "/sales/pst/getContJsonListPop",$("#contForm").serialize(), function(result) {
            AUIGrid.setGridData(contactGridID, result);
        });
    }
    
    // set Main Func (Confirm)
    function fn_setMain(dealerCntId, dealerId){ //sys.common.alert.save // <spring:message code='sys.common.alert.save'/>

        $("#tempDealerId").val(dealerId);
        $("#tempDealerCntId").val(dealerCntId); 
        Common.confirm('<spring:message code="sal.confirm.msg.confirmMainCntc" />', fn_changeMainContact, fn_noConfirm);
       
    }
    
    //call Ajax(Set Main Contact)
    function fn_changeMainContact(){
        $("#_dealerId").val($("#tempDealerId").val());
        $("#_dealerCntId").val($("#tempDealerCntId").val()); 

        Common.ajax("GET", "/sales/pst/updateDealerContactSetMain.do", $("#popForm").serialize(), function(result){
            //result alert and reload
            //Common.alert(result.message, fn_reloadPage); //차후변경가능
        	Common.alert(result.message);
            $("#_contClose").click();
            $("#autoClose").click();
            fn_selectPstRequestDOListAjax();
        });
    }
    
    function fn_reloadPage(){
        //Parent Window Method Call
        fn_selectPstRequestDOListAjax();
        Common.popupDiv('/sales/pst/getPstRequestDOEditPop.do', $('#popForm').serializeJSON(), null , true, '_editDiv3');
        $("#_contClose").click();
        $("#autoClose").click();
    }
    
    // main confirm => No
    function fn_noConfirm(){
        //Parent Window Method Call
        fn_selectPstRequestDOListAjax();

        $("#_contClose").click();
        $("#autoClose").click();
    }
    
    
   
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.title.text.editPstDealerCntc" /></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="_contClose"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.dealerMainCntc" /></h2>
</aside><!-- title_line end -->

<form id="contForm" name="contForm" method="GET">
    <input type="hidden" id="dealerId" name="dealerId" value="${dealerId}">
    <input type="hidden" id="tempDealerId" name="tempDealerId">
    <input type="hidden" id="tempDealerCntId" name="tempDealerCntId">
    <input type="hidden" name="editDealerCntId"   id="_editDealerCntId"> <!--Contact Id  -->
    <input type="hidden" name="requestdo"   id="requestdo"> <!--Contact Id  -->
</form>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.name" /></th>
    <td><span>${pstMailContMain.cntName}</span></td>
    <th scope="row"><spring:message code="sal.text.initial" /></th>
    <td><span>${pstMailContMain.dealerInitialCode}</span></td>
    <th scope="row"><spring:message code="sal.text.gender" /></th>
    <td><span>${pstMailContMain.gender}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.nric" /></th>
    <td><span>${pstMailContMain.nric}</span></td>
    <th scope="row"><spring:message code="sal.text.race" /></th>
    <td><span>${pstMailContMain.raceName}</span></td>
    <th scope="row"><spring:message code="sal.title.text.telMobile1" /></th>
    <td><span>${pstMailContMain.telM1}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.telMobile2" /></th>
    <td><span>${pstMailContMain.telM2}</span></td>
    <th scope="row"><spring:message code="sal.text.telO" /></th>
    <td><span>${pstMailContMain.telO}</span></td>
    <th scope="row"><spring:message code="sal.text.telR" /></th>
    <td><span>${pstMailContMain.telR}</span></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.telF" /></th>
    <td><span>${pstMailContMain.telf}</span></td>
    <th scope="row"></th>
    <td><span></span></td>
    <th scope="row"></th>
    <td><span></span></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.title.text.dealerCntcList" /></h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="_newContact"><spring:message code="sal.title.text.addNewCntc" /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="contact_grid_wrap" style="width:100%; height:250px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->