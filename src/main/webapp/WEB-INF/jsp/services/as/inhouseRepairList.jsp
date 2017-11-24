<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">

var   inHouseRGridID;

function fn_selInhouseList(){
        Common.ajax("GET", "/services/inhouse/selInhouseList.do", $("#inHoForm").serialize(), function(result) {
            console.log(result );
            AUIGrid.setGridData(inHouseRGridID, result);
        
        });
}



$(document).ready(function() {
    createAUIGrid() ;
  
});

function createAUIGrid() {
    
    var columnLayout = [
                        
                        {
                            headerText : "As_Entry",
                            children : [ 
                                        {dataField : "asBrnchDesc",     headerText  : "DSC Branch" ,width  : 120 ,  editable       : false  } ,
                                        { dataField : "asMemCode",     headerText  : "CT Code",  width  : 120 , editable       : false},
                                        { dataField : "asStkDesc",       headerText  : "Product",  width  : 200   , editable       : false},
                                        { dataField : "asDfDesc",         headerText  : "Defect Type",  width  : 100   , editable       : false},
                                        {dataField : "asStus",             headerText  : "AS Statu ",  width  : 120,  editable       : false}
                            ]
                        },
                        {
                            headerText : "Repair_Entry",
                            children : [ 
                                        {dataField : "reMemCode",     headerText  : "DRM Code" ,width  : 100 ,  editable       : false  } ,
                                        { dataField : "reStdDate",    headerText  : "In-house <br> Reg Date",  width  : 150 ,  dataType : "date", formatString : "dd/mm/yyyy"  ,editable       : false},
                                        { dataField : "reEndDate", headerText  : "In-house <br> End Date ",  width  : 150    ,dataType : "date", formatString : "dd/mm/yyyy"  , editable       : false},
                                        { dataField : "rePromDatem", headerText  : "Promised <br>Com Date",  width  : 150   ,dataType : "date", formatString : "dd/mm/yyyy"  , editable       : false},
                                        {dataField : "rasStus", headerText  : "Repair Statu",  width  : 120 , editable    : false}
                            ]
                        }
                        
                        
   ];   
   
    
  var gridPros = { usePaging : true,     
            headerHeight : 50,
            skipReadonlyColumns : true,
            wrapSelectionMove : true,
            showRowNumColumn : true,
            selectionMode       : "singleRow",
            editable :  false

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



function fn_addRepairPop(){
    
    var selectedItems = AUIGrid.getSelectedItems(inHouseRGridID);
    if(selectedItems.length <= 0) {
            Common.alert("<b>No Item selected.</b>");
         return ;
    }
    
    Common.popupDiv("/services/inhouse/inhouseDPop.do?mode=NEW" ,null, null , true , '_addResultDiv');
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


$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = -1;
        }

        $("#repState").val(""); 
    });
};

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
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#inHoForm').clearForm();" ><span class="clear"></span>Clear</a></p></li>
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
         <input type="text" title="" placeholder="AS Ticket Number" class="w100p" id="asNo" name="asNo"/>
    </td>
    <th scope="row">DSC Branch</th>
    <td>
          <input type="text" title="" placeholder="DSC Branch" class="w100p" id="asBrnchId" name="asBrnchId"/>
    </td>
    <th scope="row">Registration CT Code</th>
     <td>
        <input type="text" title="" placeholder="Registration CT Code" class="w100p" id="regCtCode" name="regCtCode"/>
    </td>
</tr>
<tr>
    <th scope="row">AS Status</th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="repState" name="repState">
            <option value="1"  selected>Active</option>
            <option value="4">Completed</option>
            <option value="21">Fail</option>
            <option value="10">Cancelled</option>
    </select>
    
    </td>
    <th scope="row">Repair CT Code</th>
    <td><input type="text" title="" placeholder="Repair CT Code" class="w100p" id="rePairCtCode" name="rePairCtCode"/></td>
    <th scope="row">Defect Type</th>
    <td><input type="text" title="" placeholder="Defect Type" class="w100p" id="defType" name="defType"/></td>
</tr>
<tr>
    <th scope="row">Product Code</th>
    <td><input type="text" title="" placeholder="Product Code" class="w100p" id="stkCode" name="stkCode"/></td>
    <th scope="row">Replacement Product Code</th>
    <td><input type="text" title="" placeholder="Replacement Product Code" class="w100p" id="inReProdCode" name="inReProdCode"/></td>
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
       <li><p class="link_btn"><a href="#" onclick="javascript:fn_addRepairPop()">Add Repair</a></p></li> 
       
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
