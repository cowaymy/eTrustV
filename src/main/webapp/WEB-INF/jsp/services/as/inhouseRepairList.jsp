<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">

var   inHouseRGridID;

function fn_selInhouseList(){
        Common.ajax("GET", "/services/inhouse/selInhouseList.do", $("#inHoForm").serialize(), function(result) {
            console.log("data : " + result);
            AUIGrid.setGridData(inHouseRGridID, result);
        
        });
}



$(document).ready(function() {
	createAUIGrid() ;
});

function createAUIGrid() {
    
    var columnLayout = [
                        {dataField : "c1",     headerText  : "DSC Branch" ,width  : 100 ,  editable       : false  } ,
                        { dataField : "c2",    headerText  : "CT Code",  width  : 120 , editable       : false},
                        { dataField : "c3", headerText  : "Product Code ",  width  : 120   , editable       : false},
                        { dataField : "c4", headerText  : "Defect Type",  width  : 120   , editable       : false},
                        {dataField : "c5", headerText  : "AS Ticket <br> Registration Date ",  width  : 140 ,dataType : "date", formatString : "dd/mm/yyyy"  , editable       : false},
                        {dataField : "c6", headerText  : "In-house Repair <br>Registration Date",  width  : 140 ,dataType : "date", formatString : "dd/mm/yyyy"  , editable       : false},
                        {dataField : "c7", headerText  : "Promised <br>Completion Date",  width  : 140 , 
		                        	    editRenderer : {
				                                type : "CalendarRenderer",
				                                showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
				                                onlyCalendar : true, // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
				                                showExtraDays : true, // 지난 달, 다음 달 여분의 날짜(days) 출력
				                                validator : function(oldValue, newValue, rowItem) { // 에디팅 유효성 검사
				                                    var date, isValid = true;
				                                    var msg = "";
				
				                                    if(isNaN(Number(newValue)) ) { //20160201 형태 또는 그냥 1, 2 로 입력한 경우는 허락함.
				                                        if(isNaN(Date.parse(newValue))) { // 그냥 막 입력한 경우 인지 조사. 즉, JS 가 Date 로 파싱할 수 있는 형식인지 조사
				                                            isValid = false;
				                                            msg = "Invalid Date Type.";
				                                        } else {
				                                            isValid = true;
				                                        }
				                                    }
				
				                                    if(isValid){
				                                        var dtFrom = Number(rowItem.validDtFrom.toString().replace(/\//g,""));
				                                        var dtTo = Number(rowItem.validDtTo.toString().replace(/\//g,""));
				                                        if(dtFrom != 0 && dtTo != 0 && dtFrom > dtTo){
				                                            msg = "Start date can not be greater than End date.";
				                                            isValid = false;
				                                        }
				                                    }
				                                    // 리턴값은 Object 이며 validate 의 값이 true 라면 패스, false 라면 message 를 띄움
				                                    return { "validate" : isValid, "message"  : msg };
				                            }
		                            }
                        },
                        {dataField : "c8", headerText  : "Repair",  width  : 120  , editable       : false}
   ];   
   
    
    var gridPros = { usePaging : true,     
            editable : true,
            displayTreeOpen : true,
            headerHeight : 50,
            skipReadonlyColumns : true,
            wrapSelectionMove : true,
            showRowNumColumn : true,
            selectionMode       : "singleRow"

    };  
    inHouseRGridID= GridCommon.createAUIGrid("grid_wrap_inHouseList", columnLayout  ,"" ,gridPros);
}


function fn_viewResultPop(){
	
	var selectedItems = AUIGrid.getSelectedItems(inHouseRGridID);
	if(selectedItems.length <= 0) {
	        Common.alert("<b>No Item selected.</b>");
		 return ;
	}
	
    Common.popupDiv("/services/inhouse/inhouseDPop.do?mode=view" ,null, null , true , '_viewResultDiv');

}



function fn_editResultPop(){
    
    var selectedItems = AUIGrid.getSelectedItems(inHouseRGridID);
    if(selectedItems.length <= 0) {
            Common.alert("<b>No Item selected.</b>");
         return ;
    }
    
    Common.popupDiv("/services/inhouse/inhouseDPop.do?mode=edit" ,null, null , true , '_editResultDiv');

}



function fn_addResultPop(){
    Common.popupDiv("/services/inhouse/inhouseDPop.do?mode=new" ,null, null , true , '_addResultDiv');
}


function fn_addSave(){
	

    //수정된 행 아이템들(배열)
    var editedRowItems = AUIGrid.getEditedRowItems (inHouseRGridID); 

    console.log(editedRowItems);
    if(editedRowItems.length <= 0) {
	        Common.alert("<b>No Item change.</b>");
	     return ;
     }
    var  updateForm ={
            "update" : editedRowItems
    }
    
    
    Common.ajax("POST", "/services/inhouse/mListUpdate.do",updateForm , function(result) {
        console.log( result);
        
        if(result != null ){
           // fn_setResultData(result);
        }
    });
}

</script>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>In House Repair Progress Display</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onClick="javascript:fn_selInhouseList()"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="inHoForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">AS Ticket Number</th>
    <td>
         <input type="text" title="" placeholder="AS Ticket Number" class="w100p" id="asTicketNum" name="asTicketNum"/>
    </td>
    <th scope="row">DSC Branch</th>
    <td>
          <input type="text" title="" placeholder="DSC Branch" class="w100p" id="" name=""/>
    </td>
    <th scope="row">Registration CT Code</th>
     <td>
        <input type="text" title="" placeholder="Registration CT Code" class="w100p" id="" name=""/>
    </td>
</tr>
<tr>
    <th scope="row">Repair Status</th>
    <td><input type="text" title="" placeholder="Repair Status" class="w100p" id="" name=""/></td>
    <th scope="row">Repair CT Code</th>
    <td><input type="text" title="" placeholder="Repair CT Code" class="w100p" id="" name=""/></td>
    <th scope="row">Defect Type</th>
    <td><input type="text" title="" placeholder="Defect Type" class="w100p" id="" name=""/></td>
</tr>
<tr>
    <th scope="row">Product Code</th>
    <td><input type="text" title="" placeholder="Repair Status" class="w100p" id="asNum" name=""/></td>
    <th scope="row">Replacement Product Code</th>
    <td><input type="text" title="" placeholder="Replacement Product Code" class="w100p" id="" name=""/></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

 <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
       <li><p class="link_btn"><a href="#" onclick="javascript:fn_viewResultPop()">View Result</a></p></li> 
       <li><p class="link_btn"><a href="#" onclick="javascript:fn_editResultPop()">Edit Result</a></p></li> 
       <li><p class="link_btn"><a href="#" onclick="javascript:fn_addResultPop()">Add Result</a></p></li> 
       
        <li><p class="link_btn"><a href="#" onclick="javascript:fn_addSave()">gridsave</a></p></li> 
    </ul>
   
    <ul class="btns">
        <!--<li><p class="link_btn type2"><a href="#" onclick="javascript:fn_newASPop()">New AS Application</a></p></li> -->
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

<ul class="right_btns">
    <!-- <li><p class="btn_grid"><a href="#" onClick="fn_excelDown()">EXCEL DW</a></p></li> -->
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_inHouseList" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->
</form>


</section><!-- search_table end -->
</section><!-- content end -->
