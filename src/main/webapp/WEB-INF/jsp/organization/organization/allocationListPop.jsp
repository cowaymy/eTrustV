
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<style type="text/css">

/* 커스텀 셀 스타일 */
.my-cell-style {
    background:#FF007F;
    font-weight:bold;
    color:#fff;
}
.my-row-style {
    background:#FFB2D9;
    font-weight:bold;
    color:#22741C;
}

</style>


<script type="text/javaScript" language="javascript">

var  mAgrid;
var  dAgrid;

function fn_doBack(){
	$("#_doAllactionDiv").remove();
}

$(document).ready(function(){
    
    //AUIGrid 그리드를 생성합니다.
    createAllactionAUIGrid();
    createDetailAllactionAUIGrid();
    
   // doGetCombo('/common/selectCodeList.do', '45', '','comBranchType', 'S' , ''); 
    
    AUIGrid.bind(mAgrid, "cellDoubleClick", function(event ) {
        console.log(event.item);
        fn_selectAllactionDetailListAjax();
    });
    
    AUIGrid.bind(dAgrid, "cellDoubleClick", function(event) {
        console.log(event.rowIndex);
        fn_AllocationConfirm();
    });
    
   AUIGrid.bind(dAgrid, "cellClick", function( event ) {
      
        AUIGrid.setRendererProp( dAgrid, event.columnIndex , { styleFunction : "my-cell-style" } );
   });

    
    fn_selectAllactionSelectListAjax();
});





function changeRowStyleFunction() {
    
    // row Styling 함수를 다른 함수로 변경
    AUIGrid.setProp(mAgrid, "rowStyleFunction", function(rowIndex, item) {
        
        var isrow =false;
         
        if(item.dDate == '${S_DATE}')  isrow =true; 
       // isrow =true;
       
       console.log( item.dDate +"=="+ '${S_DATE}');
       console.log( isrow);
    	if(isrow ){
            return "my-row-style";
    	}else{
    		return "";
    	}
        
    });
    
    // 변경된 rowStyleFunction 이 적용되도록 그리드 업데이트
    AUIGrid.update(mAgrid);
};


//리스트 조회.
function fn_selectAllactionSelectListAjax () {        
	
if( '${ORD_ID}' ==""){
    Common.alert("There Are No selected ORDER.");
    return ;
}
Common.ajax("GET", "/organization/allocation/selectList",{ORD_ID : '${ORD_ID}' , S_DATE: '${S_DATE}' }, function(result) {
       
    console.log(result);
    AUIGrid.setGridData(mAgrid, result);
    changeRowStyleFunction();
    
 });
}



//리스트 조회.
function  fn_selectAllactionDetailListAjax () {        
	  
	var selectedItems = AUIGrid.getSelectedItems(mAgrid);
	
	if(selectedItems.length <= 0 ){
	      Common.alert("There Are No selected Items.");
	      return ; 
	}
	
	console.log(selectedItems[0]);
	
	var v_ctId    =selectedItems[0].item.ct;
	var v_sDate =selectedItems[0].item.cDate;
	
	Common.ajax("GET", "/organization/allocation/selectDetailList", { CT_ID: v_ctId , S_DATE:v_sDate  ,P_DATE :v_sDate }, function(result) {
	         
	  console.log(result);
	  AUIGrid.setGridData(dAgrid, result);
	  
      item = {};
      item.memCode =selectedItems[0].item.memCode;
      item.ct=selectedItems[0].item.ct;
      AUIGrid.updateRow(dAgrid, item,0);
         
	});
	
	
}






function createAllactionAUIGrid() {
   
    var columnLayout = [
                          { dataField : "memCode", headerText   : "CT",    width : 150 ,editable : false    , cellMerge : true},
                          { dataField : "cDate", headerText  : "Date",width : 150 ,editable       : false },
                          {
                              headerText : "Summary",
                              children : [  {
				                            	   dataField : "ascnt",
							                       headerText : "AS",
							                       width : 200 ,editable : false 
							                    }, 
							                    {
				                                  dataField : "inscnt",
				                                  headerText : "INS",
				                                  width : 200 ,editable : false 
				                                 }, 
                                                {
                                                  dataField : "rtncnt",
                                                  headerText : "RTN",
                                                  width : 200 ,editable : false 
                                                 }
							  ]
                          }
       ];

        var gridPros = { usePaging : true,  pageRowCount: 20, editable: false, fixedColumnCount : 1,   showRowNumColumn : true};  
        
        mAgrid = GridCommon.createAUIGrid("mAgrid_grid_wrap", columnLayout  ,"" ,gridPros);
    }
    
    
    

function createDetailAllactionAUIGrid() {
        
        var columnLayout = [
                           
                            { dataField : "memCode", headerText  : "CT",    width : 100,  editable : false  ,cellMerge : true},
                            { dataField : "ct", headerText  : "",    width : 100 ,visible :false},
                            {
                                headerText : "Summary",
                                children : [  {
                                                     dataField : "sumascnt",
                                                     headerText : "AS",
                                                     width : 80,
                                                     styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {

                                                         var valArray  =new Array();
                                                         valArray = value.split("-");
                                                         
                                                    
                                                         
                                                    	 if(valArray[0] == valArray[1]  && valArray[1] >0 ) {
                                                    		 
                                                             return "my-cell-style";
                                                         }
                                                    	 if(valArray[0] > valArray[1]) {
                                                             return "my-cell-style";
                                                         }
                                                    	 
                                                         return null;
                                                     }
                                                  }, 
                                                  {
                                                    dataField : "suminscnt",
                                                    headerText : "INS",
                                                    width : 80,
                                                    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {

                                                        var valArray  =new Array();
                                                        valArray = value.split("-");
                                                        if(valArray[0] ==valArray[1] && valArray[1] >0 ) {
                                                            return "my-cell-style";
                                                        }
                                                        if(valArray[0] > valArray[1]) {
                                                            return "my-cell-style";
                                                        }
                                                        return null;
                                                    }
                                                   }, 
                                                  {
                                                    dataField : "sumrtncnt",
                                                    headerText : "RTN",
                                                    width : 80,
                                                    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {

                                                        var valArray  =new Array();
                                                        valArray = value.split("-");
                                                        if(valArray[0] ==valArray[1] && valArray[1] >0 ) {
                                                            return "my-cell-style";
                                                        }
                                                        if(valArray[0] > valArray[1]) {
                                                            return "my-cell-style";
                                                        }
                                                        return null;
                                                    }
                                                   }
                                ]
                            },
                            
                            {
                                headerText : "Morning",
                                children : [  {
                                                     dataField : "morascnt",
                                                     headerText : "AS",
                                                     width : 80,
                                                     styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {

                                                         var valArray  =new Array();
                                                         valArray = value.split("-");
                                                         if(valArray[0] ==valArray[1] && valArray[1] >0 ) {
                                                             return "my-cell-style";
                                                         }
                                                         if(valArray[0] > valArray[1]) {
                                                             return "my-cell-style";
                                                         }
                                                         return null;
                                                     }
                                                  }, 
                                                  {
                                                    dataField : "morinscnt",
                                                    headerText : "INS",
                                                    width : 80,
                                                    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {

                                                        var valArray  =new Array();
                                                        valArray = value.split("-");
                                                        if(valArray[0] ==valArray[1] && valArray[1] >0 ) {
                                                            return "my-cell-style";
                                                        }
                                                        if(valArray[0] > valArray[1]) {
                                                            return "my-cell-style";
                                                        }
                                                        return null;
                                                    }
                                                   }, 
                                                  {
                                                    dataField : "morrtncnt",
                                                    headerText : "RTN",
                                                    width : 80,
                                                    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {

                                                        var valArray  =new Array();
                                                        valArray = value.split("-");
                                                        if(valArray[0] ==valArray[1] && valArray[1] >0 ) {
                                                            return "my-cell-style";
                                                        }
                                                        if(valArray[0] > valArray[1]) {
                                                            return "my-cell-style";
                                                        }
                                                        return null;
                                                    }
                                                   }
                                ]
                            },
                            
                            {
                                headerText : "After",
                                children : [  {
                                                     dataField : "aftascnt",
                                                     headerText : "AS",
                                                     width : 80,
                                                     styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {

                                                         var valArray  =new Array();
                                                         valArray = value.split("-");
                                                         if(valArray[0] ==valArray[1] && valArray[1] >0 ) {
                                                             return "my-cell-style";
                                                         }
                                                         if(valArray[0] > valArray[1]) {
                                                             return "my-cell-style";
                                                         }
                                                         return null;
                                                     }
                                                  }, 
                                                  {
                                                    dataField : "aftinscnt",
                                                    headerText : "INS",
                                                    width : 80,
                                                    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {

                                                        var valArray  =new Array();
                                                        valArray = value.split("-");
                                                        if(valArray[0] ==valArray[1] && valArray[1] >0 ) {
                                                            return "my-cell-style";
                                                        }
                                                        if(valArray[0] > valArray[1]) {
                                                            return "my-cell-style";
                                                        }
                                                        return null;
                                                    }
                                                   }, 
                                                  {
                                                    dataField : "aftrtncnt",
                                                    headerText : "RTN",
                                                    width : 80,
                                                    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {

                                                        var valArray  =new Array();
                                                        valArray = value.split("-");
                                                        if(valArray[0] ==valArray[1] && valArray[1] >0 ) {
                                                            return "my-cell-style";
                                                        }
                                                        if(valArray[0] > valArray[1]) {
                                                            return "my-cell-style";
                                                        }
                                                        return null;
                                                    }
                                                   }
                                ]
                            },
                            
                            {
                                headerText : "Evening",
                                children : [  {
                                                     dataField : "evnascnt",
                                                     headerText : "AS",
                                                     width : 80,
                                                     styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {

                                                         var valArray  =new Array();
                                                         valArray = value.split("-");
                                                         if(valArray[0] ==valArray[1] && valArray[1] >0 ) {
                                                             return "my-cell-style";
                                                         }
                                                         if(valArray[0] > valArray[1]) {
                                                             return "my-cell-style";
                                                         }
                                                         return null;
                                                     }
                                                  }, 
                                                  {
                                                    dataField : "evninscnt",
                                                    headerText : "INS",
                                                    width : 80,
                                                    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {

                                                        var valArray  =new Array();
                                                        valArray = value.split("-");
                                                        if(valArray[0] ==valArray[1] && valArray[1] >0 ) {
                                                            return "my-cell-style";
                                                        }
                                                        if(valArray[0] > valArray[1]) {
                                                            return "my-cell-style";
                                                        }
                                                        return null;
                                                    }
                                                   }, 
                                                  {
                                                    dataField : "evnrtncnt",
                                                    headerText : "RTN",
                                                    width : 80,
                                                    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {

                                                        var valArray  =new Array();
                                                        valArray = value.split("-");
                                                        if(valArray[0] ==valArray[1] && valArray[1] >0 ) {
                                                            return "my-cell-style";
                                                        }
                                                        if(valArray[0] > valArray[1]) {
                                                            return "my-cell-style";
                                                        }
                                                        return null;
                                                    }
                                                   }
                                ]
                            },
                            
                            {
                                headerText : "Other Session",
                                children : [  {
                                                     dataField : "othascnt",
                                                     headerText : "AS",
                                                     width : 80,
                                                     styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {

                                                         var valArray  =new Array();
                                                         valArray = value.split("-");
                                                         if(valArray[0] ==valArray[1] && valArray[1] >0 ) {
                                                             return "my-cell-style";
                                                         }
                                                         if(valArray[0] > valArray[1]) {
                                                             return "my-cell-style";
                                                         }
                                                         return null;
                                                     }
                                                  }, 
                                                  {
                                                    dataField : "othinscnt",
                                                    headerText : "INS",
                                                    width : 80,
                                                    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {

                                                        var valArray  =new Array();
                                                        valArray = value.split("-");
                                                        if(valArray[0] ==valArray[1] && valArray[1] >0 ) {
                                                            return "my-cell-style";
                                                        }
                                                        if(valArray[0] > valArray[1]) {
                                                            return "my-cell-style";
                                                        }
                                                        return null;
                                                    }
                                                   }, 
                                                  {
                                                    dataField : "othrtncnt",
                                                    headerText : "RTN",
                                                    width : 80,
                                                    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {

                                                        var valArray  =new Array();
                                                        valArray = value.split("-");
                                                        if(valArray[0] ==valArray[1] && valArray[1] >0 ) {
                                                            return "my-cell-style";
                                                        }
                                                        if(valArray[0] > valArray[1]) {
                                                            return "my-cell-style";
                                                        }
                                                        return null;
                                                    }
                                                   }
                                ]
                            }
                            
                          
       ];

        var gridPros = { usePaging : true,  editable: false, fixedColumnCount : 1,  showRowNumColumn : true};  
        
        dAgrid = GridCommon.createAUIGrid("dAgrid_grid_wrap", columnLayout  ,"" ,gridPros);
    }
    


function fn_AllocationConfirm(){
	
	var selectedItemsMain = AUIGrid.getSelectedItems(mAgrid);
	
	
    var selectedItems = AUIGrid.getSelectedItems(dAgrid);
    
    if(selectedItems.length <= 0 ){
          Common.alert("There Are No selected Items.");
          return ;
    }
    var str = "";
    var i, rowItem, rowInfoObj, dataField;
    
    for(i=0; i<selectedItems.length; i++) {
        rowInfoObj = selectedItems[i];
        
        
        var valArray  =new Array();
        valArray = rowInfoObj.value.split("-");
    
        if(rowInfoObj.dataField =="sumascnt" ||  rowInfoObj.dataField =="suminscnt" ||  rowInfoObj.dataField =="sumrtncnt"   ){
        	Common.alert("Summary 는 선택할 수 없습니다.");
        	
            return ;
        }
        
        
        if(valArray[1] == "0" ){
            Common.alert("선택하신 세션에 CAPA가 등록 되지 않았습니다.");
            return ;
        }
        
        
       if(valArray[0] == valArray[1] ){
            Common.alert("선택된 세션는 이미 완료 되었습니다. 다른 세션을 선택하세요 ");
            return ;
       }
        

        if(valArray[0] >  valArray[1]){
            Common.alert("선택된 세션는 이미 초과된 상태입니다. 다른 세션을 선택하세요 ");
            return ;
        }
    }
    
    
    var sessionText;
    if(rowInfoObj.dataField =="morascnt" ||  rowInfoObj.dataField =="morinscnt" ||  rowInfoObj.dataField =="morrtncnt"     ){
    	sessionCode ="M";
    }
    
    if(rowInfoObj.dataField =="othascnt" ||  rowInfoObj.dataField =="othinscnt" ||  rowInfoObj.dataField =="othrtncnt"  ){
        sessionCode ="O";
    }
    
    if(rowInfoObj.dataField =="evnascnt" ||  rowInfoObj.dataField =="evninscnt" ||  rowInfoObj.dataField =="evnrtncnt"     ){
        sessionCode ="E";
    }
    
    if(rowInfoObj.dataField =="aftascnt" ||  rowInfoObj.dataField =="aftinscnt" ||  rowInfoObj.dataField =="aftrtncnt"   ){
        sessionCode ="A";
    }
    
    console.log("sessionCode===> "+sessionCode);
    
    $("#CTSSessionCode").val(sessionCode);
    $("#CTCode").val(selectedItems[0].item.memCode);    
    $("#CTID").val(selectedItems[0].item.ct);  
    $("#CTgroup").val(selectedItems[0].item.ctSubGrp); 
    $("#appDate").val(selectedItemsMain[0].item.dDate); 
    
    
    
    $("#_doAllactionDiv").remove();
    
}


function fn_doAllocationResult(){
	
	
	
}

</script>




<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>CT Allocation Matrix </h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#"   >CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="search_result mt30"><!-- search_result start -->


	
	<aside class="title_line"><!-- title_line start -->
	   <h4>Information Display</h4>
	</aside><!-- title_line end -->
	
	<article class="grid_wrap"><!-- grid_wrap start -->
	      <div id="mAgrid_grid_wrap" style="width:100%; height:200px; margin:0 auto;"></div>
	</article><!-- grid_wrap end -->
	
	<aside class="title_line"><!-- title_line start -->
      <h4>Detail Information</h4>
	</aside><!-- title_line end -->
	
	<article class="grid_wrap"><!-- grid_wrap start -->
	      <div id="dAgrid_grid_wrap" style="width:100%; height:200px; margin:0 auto;"></div>
	</article><!-- grid_wrap end -->
</section><!-- search_result end -->


<ul class="center_btns mt20">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_AllocationConfirm()">Allocation Confirm</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->





<script> 
	
	
</script>























