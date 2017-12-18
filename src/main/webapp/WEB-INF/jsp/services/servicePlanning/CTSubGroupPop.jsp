
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript">
var gridCtSubgrpID;
function tagRespondGrid() {
        
        var columnCtSubgrpLayout =[
                                       {
                                           dataField: "ctSubGrp",
                                           headerText: "CT Sub Group",
                                           width: 160
                                       },
                                       {
                                           dataField: "asignFlag",
                                           headerText: "Assign",
                                           width: 160
                                       }, {
                                           dataField : "checkFlag",
                                           headerText : '<input type="checkbox" id="allCheckbox" style="width:15px;height:15px;">',
                                           width: 65,
                                           renderer : {
                                               type : "CheckBoxEditRenderer",
                                               showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                               editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                               checkValue : "1", // true, false 인 경우가 기본
                                               unCheckValue : "0"
                                           }
                                       },
                                       {
                                           dataField: "majorGrp",
                                           headerText: "Major",
                                           width: 160
                                       }, {
                                           dataField : "radioFlag",
                                           headerText : '<input type="checkbox" id="singleCheckbox" style="width:15px;height:15px;">',
                                           width: 65,
                                           renderer : {
                                               type : "CheckBoxEditRenderer",
                                               showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                               editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                               checkValue : "1", // true, false 인 경우가 기본
                                               unCheckValue : "0"
                                           }
                                       }
                                      
                           
                               ];
                       
    var gridCtSubgrpPros = {  
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
            selectionMode       : "singleRow",  //"multipleCells",            
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
            editable :false 
    };  
    
    gridCtSubgrpID = GridCommon.createAUIGrid("CTList_grid_wap", columnCtSubgrpLayout  ,"" ,gridCtSubgrpPros);


}

    $(document).ready(function(){
        
        //grid 생성
        tagRespondGrid();
        var memberId = $("#memID").val();
        
        Common.ajax("GET","/services/serviceGroup/selectCtSubGrp",{memId : memberId},function(result) {
            console.log("성공.");
            console.log("data : "+ result);
            AUIGrid.setGridData(gridCtSubgrpID,result);
            for(var i=0; i< AUIGrid.getGridData(gridCtSubgrpID).length; i++){
                if(AUIGrid.getCellValue(gridCtSubgrpID, i, "asignFlag") != null && AUIGrid.getCellValue(gridCtSubgrpID, i, "asignFlag") != ""){
                    AUIGrid.updateRow(gridCtSubgrpID, { "checkFlag" : 1 }, i);
                }
            }
        });
        
      
    });


</script>


<!-- ================== Design ===================   -->
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Assign CT Sub Group</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<input type="hidden" id="memID" name="memId" value="${params.memId}">



<aside class="title_line"><!-- title_line start -->
<h2>CT Sub Group Assign</h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" onclick="javascript:fn_AssignSubgroup()">Assign</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="CTList_grid_wap" style="width:100%; height:300px; margin:0 auto;">
    <input type="radio" name="majorGrp" class="majorGrp"  checked="checked" />

</div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" onclick="javascript:fn_CTAssignSave()">Save</a></p></li>
</ul>

</section><!-- pop_body end -->
</div>