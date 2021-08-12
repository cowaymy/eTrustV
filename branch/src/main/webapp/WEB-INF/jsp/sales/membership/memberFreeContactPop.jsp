<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript" language="javascript">



var oCutGridID;

$(document).ready(function(){
    
    //AUIGrid 그리드를 생성합니다.
    createAUIGridCList();
    
    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(oCutGridID, "cellDoubleClick", function(event) {});
    
    fn_initListAjax();
});


function createAUIGridCList() {
    
    //AUIGrid 칼럼 설정
    var columnLayout = [
                   {     dataField     : "name",                 
                               headerText  : "<spring:message code="sal.text.name" />",  
                               width          : 120,               
                               editable       : false
                        }, 
                   {     dataField     : "nric",          
                               headerText  : "<spring:message code="sales.NRIC" />",           
                               width          : 120,                
                               editable       : false
                        }, 
                   {     dataField     : "telM1",                     
                               headerText  : "<spring:message code="sales.MobileNo" />",           
                               width          :120,                 
                               editable       : false
                        }, 
                   {      dataField     : "telO",                
                                headerText  : "<spring:message code="sales.OfficeNo" />",           
                                width          : 120,                 
                                editable       : false
                        }, 
                   {      dataField       : "telR",      
                               headerText   : "<spring:message code="sal.title.residenceNo" />",           
                               width           : 120,                 
                               editable        : false
                        }, 
                   {      dataField       : "telf",      
                               headerText   : "<spring:message code="sal.title.faxNo" />",           
                               width           :100,                 
                               editable        : false
                        }, 
                   {      dataField       : "codename1",      
                               headerText   : "<spring:message code="sal.title.race" />",           
                               width           : 100,                 
                               editable        : false
                        }, 
                   {
                            dataField : "undefined",
                            headerText : " ",
                            width           : 100,    
                            renderer : {
                                type : "ButtonRenderer",
                                labelText : "Select",
                                onclick : function(rowIndex, columnIndex, value, item) {
                                    fn_addContactPersonInfo(item);
                                    $("#c_close").click();
                                }
                            }
                        }
                        
   ];
    
    

    //그리드 속성 설정
    var gridPros = {
        usePaging              : true,         //페이징 사용
        pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
        editable                 : false,            
        fixedColumnCount    : 1,            
        showStateColumn    : true,             
        displayTreeOpen      : false,            
        //selectionMode         : "singleRow",  //"multipleCells",            
        headerHeight          : 30,       
        useGroupingPanel      : false,         //그룹핑 패널 사용
        skipReadonlyColumns  : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove    : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn  : true         //줄번호 칼럼 렌더러 출력  
    };
    
    
    oCutGridID = GridCommon.createAUIGrid("cList_grid_wrap", columnLayout ,"",gridPros);
}


// 리스트 조회.
function fn_initListAjax() {        
   Common.ajax("GET", "/sales/membership/selectMembershipContatList", $("#getDataForm").serialize(), function(result) {
        console.log( result);
        AUIGrid.setGridData(oCutGridID, result);
   });  
}




//리스트 조회.
function fn_selectListAjax() {        
Common.ajax("GET", "/sales/membership/selectMembershipContatList", $("#contactForm").serialize(), function(result) {
		
	     console.log( result);
	     AUIGrid.setGridData(oCutGridID, result);
     });  
}


function fn_doClear() {

    $("#NAME").val ("");
    $("#NRIC").val ("");
    $("#CONTACT_NO").val("");
}



</script>


<form id="contactForm" name="contactForm">
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.contactPersonSearch" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue"><a href="#"  onclick="javascript:fn_selectListAjax()"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
	<li><p class="btn_blue"><a href="#"  onclick="javascript:fn_doClear()"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
	<li><p class="btn_blue2"><a href="#" id="c_close"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:110px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.text.name" /></th>
	<td><input type="text" title=""  id="NAME"  name='NAME'  placeholder="" class="w100p" /></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sales.NRIC" /></th>
	<td><input type="text" title="" id="NRIC"  name="NRIC"  placeholder="" class="w100p" /></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.contactNo" /></th>
	<td><input type="text" title="" placeholder="" id='CONTACT_NO' name='CONTACT_NO' class="w100p" /></td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
     <div id="cList_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</form>
</body>