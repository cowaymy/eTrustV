<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">


var assignCtListGridID;
var assignCOrdtListGridID;


$(document).ready(function() {
	
	createAssignCtListAUIGrid();
	createAssignCtOrderListAUIGrid();
	
	fn_asaAssignCtList();
	fn_asaAssignCtOderList();
});




function createAssignCtListAUIGrid() {
    
    var columnLayout = [
                        {dataField : "ctCode",     headerText  : "CT Code" ,width  : 100 ,  editable       : false  } ,
                        { dataField : "ctName",    headerText  : "CT Name",  width  : 120 , editable       : false},
                        { dataField : "branchName", headerText  : "Branch Name ",  width  : 120  },
                        { dataField : "ctSubGrp", headerText  : "CT GRP",  width  : 120  },
                        {dataField : "ctId", headerText  : "CT ID ",  width  : 120        ,visible : false}
                     
   ];   
   
    
    var gridPros = { usePaging : true,     
    		  
            editable : true,
            displayTreeOpen : true,
            headerHeight : 30,
            skipReadonlyColumns : true,
            wrapSelectionMove : true,
            showRowNumColumn : true,
            showRowCheckColumn : true,       
            rowCheckToRadio : true
    };  
    assignCtListGridID= GridCommon.createAUIGrid("aCtL_grid_wrap", columnLayout  ,"" ,gridPros);
}



// 체크된 아이템 얻기
function fn_getAssionCTListCheckedRowItems() {

  var checkedItems = AUIGrid.getCheckedRowItems(assignCtListGridID);
	
  
  console.log(checkedItems);
  
  if(checkedItems.length  == 0  ||  checkedItems == null) {
	  Common.alert("<b>No CT List selected.</b>");
      return  false ;
  }
  
	  var str = [];
	  var rowItem = checkedItems[0].item;
	 str[0] = rowItem.ctCode;
	 str[1] = rowItem.ctId;
	
	 return str;
}

function createAssignCtOrderListAUIGrid() {
    
    var columnLayout = [
                        {
                               renderer : {
	                            type : "CheckBoxEditRenderer",
	                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                            editable : false, // 체크박스 편집 활성화 여부(기본값 : false)
	                            checkValue : "1", // true, false 인 경우가 기본
	                            width : 30,
	                            unCheckValue : "0",
	                         // 체크박스 Visible 함수
	                            checkableFunction  : function(rowIndex, columnIndex, value, isChecked, item, dataField) {
	                            	
	                                var assiinCd = fn_getAssionCTListCheckedRowItems(); 
	                                if(assiinCd  ==false ) return false;
	                               
	                                if(item.c1 == 1){
	                                    AUIGrid.updateRow(assignCOrdtListGridID, { 
	                                          "memCode" : "",
	                                          "asMemId" : ""
	                                        }, rowIndex); 
	                                }else{
	                                    AUIGrid.updateRow(assignCOrdtListGridID, { 
	                                         "memCode" : assiinCd[0],      
	                                          "asMemId" : assiinCd[1] 
	                                      }, rowIndex); 
	                                }
	                                return true;
	                            }
	                        } 
                        },
                        {dataField : "custName",         headerText  : "Customer" ,width  : 150 } ,
                        { dataField : "salesOrdNo",      headerText  : "SalesOrder",  width  : 100},
                        { dataField : "memCode",        headerText  : "Ct Code",  width  : 80  },
                        { dataField : "custSubGrp",     headerText  : "Cust GRP",  width  : 100  },
                        { dataField : "asMemId",         headerText  : "CT ID ",  width  : 100   ,     visible : false},
                        { dataField : "asId",                headerText  : "asId ID ",  width  : 100   ,     visible : false}

                     
   ];   
   
    
    var gridPros = { usePaging : true, 
				            editable : true,
				            displayTreeOpen : true,
				            headerHeight : 30,
				            skipReadonlyColumns : true,
				            wrapSelectionMove : true,
				            showRowNumColumn : true
    };  
    assignCOrdtListGridID= GridCommon.createAUIGrid("aCtOrd_grid_wrap", columnLayout  ,"" ,gridPros);
}


function fn_ctChange(){
	
	//수정된 행 아이템들(배열)
    var editedRowItems = AUIGrid.getEditedRowItems(assignCOrdtListGridID); 
    
	
	if(editedRowItems.length  == 0  ||  editedRowItems == null) {
        Common.alert("<b>No CTOrder List  selected.</b>");
        return  false ;
    }

    var  updateForm ={
            "update" : editedRowItems
    }
    
    Common.ajax("POST", "/services/as/assignCtOrderListSave.do", updateForm, function(result) {
        console.log("updateAssignCT.");
        console.log( result);         
        
        if(result  !=""){
            Common.alert("<b>AS result successfully saved.</b>");
            fn_searchASManagement();
        }
    });
    
    
}

function fn_asaAssignCtList(){
	
	var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
	
	var  brnch_id ;
	brnch_id =selectedItems[0].item.asBrnchId;
	
    Common.ajax("GET", "/services/as/assignCtList.do",{BRNCH_ID:brnch_id}, function(result) {
        console.log("fn_asaAssignCtList.");
        console.log(result);
        AUIGrid.setGridData(assignCtListGridID, result);     
    });
}



function fn_asaAssignCtOderList(){
    
    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);
    
    var asNoArray =[];
    
    for( var  i in selectedItems){
    	asNoArray.push(selectedItems[i].item.asNo)
    }
    
    var obj =JSON.stringify(asNoArray).replace(/[\[\]\"]/gi, '') ;
    
    Common.ajax("GET", "/services/as/assignCtOrderList.do", {asNo:obj}, function(result) {
        console.log("fn_asaAssignCtOderList.");
        console.log(result);
      
        AUIGrid.setGridData(assignCOrdtListGridID, result);     
        
        
    });
}

</script>




<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Assign CT Change</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="javascript:fn_ctChange();" >Assign CT Change</a></p></li>
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>

</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<div class="divine_auto"><!-- divine_auto start -->


<div style="width: 50%;">
<aside class="title_line"><!-- title_line start -->
<h2>CT List</h2>
</aside><!-- title_line end -->
		
		<div class="border_box" style="height:400px"><!-- border_box start -->

		<ul class="right_btns">
		<!--     <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
		    <li><p class="btn_grid"><a href="#">NEW</a></p></li> -->
		</ul>
		
		<article class="grid_wrapCd"><!-- grid_wrap start -->
		<div id="aCtL_grid_wrap" style="width: 100%; height: 334px; margin: 0 auto;"></div>
		</article><!-- grid_wrap end -->
		
		</div><!-- border_box end -->

</div>
<div style="width:50%;">
		
		<aside class="title_line"><!-- title_line start -->
		<h2>CT Order List</h2>
		</aside><!-- title_line end -->
		
		<div class="border_box" style="height:400px; width: 450px"><!-- border_box start -->
		
		<ul class="right_btns">
		<!--     <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
		    <li><p class="btn_grid"><a href="#">NEW</a></p></li> -->
		</ul>
		
		<article class="grid_wrapCust"><!-- grid_wrap start -->
		      <div id="aCtOrd_grid_wrap" style="width:100%; height: 334px; margin: 0 auto;"></div>
		</article><!-- grid_wrap end -->
		</div><!-- border_box end -->

</div>
</div>

</div><!-- divine_auto end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
