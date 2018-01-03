
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<style type="text/css">

/* 커스텀 셀 스타일 */
.my-cell-style {
    background:#FFB2D9;
    font-weight:bold;
    color:#fff;
}


.my-cell-style-sel {   
    background:#86E57F;
    font-weight:bold;
    color:#fff;
}


/*    핑크 불가능색 */
.my-row-style {
    background:#FFB2D9;
    font-weight:bold;
    color:#22741C;
}

/*    퍼런색  가능색 */
.my-row-style-Available{
    background:#86E57F;
    font-weight:bold;
    color:#22741C;
}



</style>


<script type="text/javaScript" language="javascript">

var  mAgrid;
var  dAgrid;


var detailSelRowIndex ;
var detailSelCellIndex ;

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
        console.log(event);
      
        if(event.headerText != '${TYPE}'){ 
        	return ;
        }
        
        
        detailSelRowIndex = event.rowIndex;
        detailSelCellIndex  = event.columnIndex;
        
        setDetailEvent();
      
    });
    
   AUIGrid.bind(dAgrid, "cellClick", function( event ) {
        AUIGrid.setRendererProp( dAgrid, event.columnIndex , { styleFunction : "my-cell-style" } );
   });

   
   // 그룹핑  이벤트  바인딩
   AUIGrid.bind(mAgrid, "grouping", function(event) {
       // 보관된 소팅 정보로 그룹핑 후 소팅 실시함
       if(typeof sortingInfo != "undefined") {
           AUIGrid.setSorting(mAgrid, sortingInfo);
       }
   });
   

   // 그리드 ready 이벤트 바인딩
  AUIGrid.bind(mAgrid, "ready", function(event) {
       // 최초에 정렬된 채로 그리드 출력 시킴.
       AUIGrid.setSorting(mAgrid, { dataField : "cDate", sortType : 1 });
  });

     // 정렬 이벤트 바인딩
  AUIGrid.bind(mAgrid, "sorting", function(event) {

         // 소팅 정보 보관.
         sortingInfo = event.sortingFields;
  });
  
    
    fn_selectAllactionSelectListAjax();
});



function setDetailEvent(){
	    
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
	    

        var valArray  =new Array();
	    var selectedValue = AUIGrid.getCellValue(dAgrid, detailSelRowIndex, detailSelCellIndex);
	    valArray = selectedValue.split("-");
	    AUIGrid.setCellValue(dAgrid, detailSelRowIndex ,      detailSelCellIndex , (Number(valArray[0])+1)  +"-"+  Number(valArray[1]) );
	    AUIGrid.setSelectionByIndex(dAgrid, detailSelRowIndex,detailSelCellIndex);
	       
	  });
    
}


function changeRowStyleFunction() {
    
    // row Styling 함수를 다른 함수로 변경
    AUIGrid.setProp(mAgrid, "rowStyleFunction", function(rowIndex, item) {
        
        
    	
        if(item.dDate == '${S_DATE}')  {
           
            if('AS'== '${TYPE}'){
            	
                  var valArray  =new Array();
                  valArray = item.ascnt.split("-");
                  
                  console.log(valArray);
                  
                  if( Number(valArray[0]) ==  Number(valArray[1])   ||  Number(valArray[0])  >=  Number(valArray[1])  ) {
                      console.log("in========>");
                	  return "my-row-style";
                	  
                  }else {
                	  return "my-row-style-Available";
                  }
                  
              
        	  }else if('INS'== '${TYPE}'){
        		  
        		  var valArray  =new Array();
                  valArray = item.inscnt.split("-");
                  console.log(valArray);
                  
               
                  if(Number(valArray[0]) == Number(valArray[1])  ||  Number(valArray[0])  >=  Number(valArray[1])  ) {
                	   console.log("my-row-style======>");
                	   
                      return "my-row-style";
                  }else {
                	  
                	   console.log("my-row-style-Available======>");
                      return "my-row-style-Available";
                  }
                  
                  
            	  
              }else if('RTN'== '${TYPE}'){
            	  var valArray  =new Array();
                  valArray = item.rtncnt.split("-");
                  if(Number(valArray[0]) == Number(valArray[1])  ||  Number(valArray[0])  >=  Number(valArray[1])   ) {
                      return "my-row-style";
                  }else {  
                      return "my-row-style-Available";
                  }
              }
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
                          { dataField : "reMemCode", headerText   : "CT",    width : 150 ,editable : false    , cellMerge : true},
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
    var gridPros = { usePaging : true,  editable: false, fixedColumnCount : 1,  showRowNumColumn : true};  
      
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
                                                         
                                                    
                                                    	 if(Number(valArray[0]) > Number(valArray[1])) {
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
	                                                    
	                                                        if(Number(valArray[0]) > Number(valArray[1])) {
	                                                            return "my-cell-style";
	                                                        }
	                                                        
	                                                        if(Number(valArray[0]) == 0  &&  Number(valArray[1]) ==0) {
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
                                                   
                                                        
                                                        if(Number(valArray[0]) > Number(valArray[1])) {
                                                            return "my-cell-style";
                                                        }
                                                        
                                                        
                                                        if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
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
                                                   
                                                         
                                                         if( Number(valArray[0]) > Number(valArray[1])) {
                                                             return "my-cell-style";
                                                         }
                                                         
                                                         
                                                         if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                             return "my-cell-style";
                                                         }
                                                         
                                                         if('AS'== '${TYPE}'){
                                                        	 return "my-cell-style-sel";
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
                                                 
                                                        if(Number(valArray[0]) > Number(valArray[1])) {
                                                            return "my-cell-style";
                                                        }
                                                        
                                                        if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                            return "my-cell-style";
                                                        }
                                                        
                                                        
                                                        if('INS'== '${TYPE}'){
                                                            return "my-cell-style-sel";
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
                                                   
                                                        if(Number(valArray[0]) > Number(valArray[1])) {
                                                            return "my-cell-style";
                                                        }
                                                        
                                                        
                                                        if(Number(valArray[0]) == 0 &&  Number(valArray[1] )==0) {
                                                            return "my-cell-style";
                                                        }
                                                        
                                                        if('RTN'== '${TYPE}'){
                                                            return "my-cell-style-sel";
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
                                                 
                                                         if(Number(valArray[0]) > Number(valArray[1])) {
                                                             return "my-cell-style";
                                                         }   
                                                         if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                             return "my-cell-style";
                                                         }
                                                         
                                                         

                                                         
                                                         if('AS'== '${TYPE}'){
                                                             return "my-cell-style-sel";
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
                                              
                                                        if(Number(valArray[0]) > Number(valArray[1])) {
                                                            return "my-cell-style";
                                                        }
                                                        
                                                        
                                                        if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                            return "my-cell-style";
                                                        }
                                                        

                                                        if('INS'== '${TYPE}'){
                                                            return "my-cell-style-sel";
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
                                                   
                                                        if(Number(valArray[0]) >  Number(valArray[1])) {
                                                            return "my-cell-style";
                                                        }
                                                        
                                                        if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                            return "my-cell-style";
                                                        }
                                                        
                                                        if('RTN'== '${TYPE}'){
                                                            return "my-cell-style-sel";
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
                                                
                                                         
                                                         if(Number(valArray[0]) >  Number(valArray[1])) {
                                                             return "my-cell-style";
                                                         }
                                                         
                                                         if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                             return "my-cell-style";
                                                         }
                                                         
                                                         
                                                         if('AS'== '${TYPE}'){
                                                             return "my-cell-style-sel";
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
                                                   
                                                        if(Number(valArray[0]) > Number(valArray[1])) {
                                                            return "my-cell-style";
                                                        }
                                                        
                                                        if('INS'== '${TYPE}'){
                                                            return "my-cell-style-sel";
                                                        }
                                                        
                                                        if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
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
                                                 
                                                        if(Number(valArray[0]) >  Number(valArray[1])) {
                                                            return "my-cell-style";
                                                        }
                                                        
                                                        if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                            return "my-cell-style";
                                                        }
                                                        

                                                        if('RTN'== '${TYPE}'){
                                                            return "my-cell-style-sel";
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
                                                         /*
                                                         var valArray  =new Array();
                                                         valArray = value.split("-");
                                                    
                                                         
                                                         if(Number(valArray[0]) == 0 &&  Number(valArray[1]) ==0) {
                                                             return "my-cell-style";
                                                         }
                                                         
                                                         if(Number(valArray[0]) > Number( valArray[1] )) {
                                                             return "my-cell-style";
                                                         }
                                                   
                                                 
                                               
                                                        
                                                         if('AS'== '${TYPE}'){
                                                             return "my-cell-style-sel";
                                                         }
                                                         */
                                                         return null;
                                                     }
                                                  }, 
                                                  {
                                                    dataField : "othinscnt",
                                                    headerText : "INS",
                                                    width : 80,
                                                    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
                                                    	 /*
                                                        var valArray  =new Array();
                                                        valArray = value.split("-");
                                                        if(Number(valArray[0]) == 0 &&   Number(valArray[1]) ==0) {
                                                            return "my-cell-style";
                                                        }
                                                        if(  Number(valArray[0])  >  Number(valArray[1])) {
                                                            return "my-cell-style";
                                                        }
                                                 
                                                       
                                                      
                                                        
                                                        
                                                   
                                                        
                                                        if('INS'== '${TYPE}'){
                                                            return "my-cell-style-sel";
                                                        }
                                                        */
                                                        return null;
                                                    }
                                                   }, 
                                                  {
	                                                    dataField : "othrtncnt",
	                                                    headerText : "RTN",
	                                                    width : 80,
	                                                    styleFunction :  function(rowIndex, columnIndex, value, headerText, item, dataField) {
	                                                        /*
		                                                        var valArray  =new Array();
		                                                        valArray = value.split("-");
		                                                        
		                                                        if(Number( valArray[0] )== 0  &&  Number(valArray[1]) ==0) {
                                                                    return "my-cell-style";
                                                                }
		                                                        if( Number( valArray[0]  )>  Number(valArray[1] )) {
                                                                    return "my-cell-style";
                                                                }
		                                                     
		                                                    
		                                                   
		                                                        
		                                                      
		
		                                                        if('RTN'== '${TYPE}'){
		                                                            return "my-cell-style-sel";
		                                                        }
		                                                        */
		                                                        return null;
		                                                   }
	                                                   }
                                ]
                            }
                            
                          
       ];

        var gridPros = { usePaging : true,  editable: false, fixedColumnCount : 1,  showRowNumColumn : true};  
        
        dAgrid = GridCommon.createAUIGrid("dAgrid_grid_wrap", columnLayout  ,"" ,gridPros);
        
        AUIGrid.bind(dAgrid, ["cellEditEnd", "cellEditCancel"], auiCellEditingHandler);
    }
    


function fn_AllocationConfirm(){
	
	var selectedItemsMain = AUIGrid.getSelectedItems(mAgrid);
    var selectedItems = AUIGrid.getSelectedItems(dAgrid);
    
    
    console.log(selectedItems);
    
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
        	Common.alert("Summary can not be selected.");
            return ;
        }
        
        
        if(rowInfoObj.dataField !="othascnt"  &&   rowInfoObj.dataField !="othinscnt" && rowInfoObj.dataField !="othrtncnt"  ){

            if(Number(valArray[1]) == "0" ){
                Common.alert("CAPA is not registered in the selected session.");
                return ;
            }
            
            
           if(Number(valArray[0]) >  Number(valArray[1]) ){
                Common.alert("The selected session has already been completed. Please select another session ");
                return ;
           }
        }
        
    }
    
    
    var sessionText;
    var sessionCode;
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
    
    if( '${CallBackFun}' !=''){
     
    	  rtnObj = new Object();
    	  
    	  rtnObj.sessionCode = sessionCode;
    	  rtnObj.memCode = selectedItems[0].item.memCode;
    	  rtnObj.ct = selectedItems[0].item.ct;
    	  rtnObj.ctSubGrp = selectedItems[0].item.ctSubGrp;
    	  rtnObj.dDate = selectedItemsMain[0].item.dDate;
    	  rtnObj.brnchId = selectedItemsMain[0].item.brnchId;
    	 
    	  $("#_doAllactionDiv").remove();
    	  eval(${CallBackFun}(rtnObj));
    	  
    }else{
    	$("#CTSSessionCode").val(sessionCode);
        $("#CTCode").val(selectedItems[0].item.memCode);    
        $("#CTID").val(selectedItems[0].item.ct);  
        $("#CTgroup").val(selectedItems[0].item.ctSubGrp); 
        $("#appDate").val(selectedItemsMain[0].item.dDate); 
        $("#branchDSC").val(selectedItemsMain[0].item.brnchId); 
        
        console.log("branchDSC  =>"+selectedItemsMain[0].item.brnchId);
        
        $("#_doAllactionDiv").remove();
    	
    }
    
    
}


function fn_doAllocationResult(){
	
	
	
}


function auiCellEditingHandler(event) {
	
    

  
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
	      <div id="mAgrid_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
	</article><!-- grid_wrap end -->
	
	<aside class="title_line"><!-- title_line start -->
      <h4>Detail Information</h4>
	</aside><!-- title_line end -->
	
	<article class="grid_wrap"><!-- grid_wrap start -->
	      <div id="dAgrid_grid_wrap" style="width:100%; height:200px; margin:0 auto;"></div>
	</article><!-- grid_wrap end -->
</section><!-- search_result end -->


<input type ='hidden'  value='${TYPE}'/> 

<ul class="center_btns mt20">
    <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_AllocationConfirm()">Allocation Confirm</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->





<script> 
	
	
</script>























