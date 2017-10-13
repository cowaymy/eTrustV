<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
.aui-grid-user-custom-right {
    text-align:right;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}

.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
}

</style>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var listGrid;
var reqGrid;
var serialGrid;

var rescolumnLayout=[{dataField:"rnum"         ,headerText:"RowNum"                      ,width:120    ,height:30 , visible:false},
                     {dataField:"status"       ,headerText:"Status"                      ,width:120    ,height:30 , visible:false},
                     {dataField:"reqstno"      ,headerText:"Stock Movement Request"      ,width:120    ,height:30                },
                     {dataField:"staname"      ,headerText:"Status"                      ,width:120    ,height:30                },
                     {dataField:"reqitmno"     ,headerText:"Stock Movement Request Item" ,width:120    ,height:30 , visible:false},
                     {dataField:"ttype"        ,headerText:"Transaction Type"            ,width:120    ,height:30 , visible:false},
                     {dataField:"ttext"        ,headerText:"Transaction Type Text"       ,width:120    ,height:30                },
                     {dataField:"mtype"        ,headerText:"Movement Type"               ,width:120    ,height:30 , visible:false},
                     {dataField:"mtext"        ,headerText:"Movement Text"               ,width:120    ,height:30                },
                     {dataField:"froncy"       ,headerText:"Auto / Manual"               ,width:120    ,height:30                },
                     {dataField:"crtdt"        ,headerText:"Request Create Date"         ,width:120    ,height:30                },
                     {dataField:"reqdate"      ,headerText:"Request Required Date"       ,width:120    ,height:30                },
                     {dataField:"rcvloc"       ,headerText:"From Location"               ,width:120    ,height:30 , visible:false},
                     {dataField:"rcvlocnm"     ,headerText:"From Location"               ,width:120    ,height:30 , visible:false},
                     {dataField:"rcvlocdesc"   ,headerText:"From Location"               ,width:120    ,height:30                },
                     {dataField:"reqloc"       ,headerText:"To Location"                 ,width:120    ,height:30 , visible:false},
                     {dataField:"reqlocnm"     ,headerText:"To Location"                 ,width:120    ,height:30 , visible:false},
                     {dataField:"reqlocdesc"   ,headerText:"To Location"                 ,width:120    ,height:30                },
                     {dataField:"itmcd"        ,headerText:"Material Code"               ,width:120    ,height:30 , visible:true},
                     {dataField:"itmname"      ,headerText:"Material Name"               ,width:120    ,height:30                },
                     {dataField:"reqstqty"     ,headerText:"Requested Qty"                 ,width:120    ,height:30                },
                     {dataField:"rmqty"        ,headerText:"Remain Qty"                 ,width:120    ,height:30                },
                     {dataField:"delvno"       ,headerText:"delvno"                      ,width:120    ,height:30 , visible:false},
                     {dataField:"delyqty"      ,headerText:"delvno"                      ,width:120    ,height:30 , visible:false},
                     {dataField:"indelyqty"      ,headerText:"Delivered Qty"                ,width:120    ,height:30 , editable:true 
                    	 ,dataType : "numeric" ,editRenderer : {
                             type : "InputEditRenderer",
                             onlyNumeric : true, // 0~9 까지만 허용
                             allowPoint : false // onlyNumeric 인 경우 소수점(.) 도 허용
                       }
                     },
                     {dataField:"greceipt"     ,headerText:"Good Receipted"                ,width:120    ,height:30                },
                     {dataField:"uom"          ,headerText:"Unit of Measure"             ,width:120    ,height:30 , visible:false},
                     {dataField:"uomnm"        ,headerText:"Unit of Measure"             ,width:120    ,height:30                }];
var reqcolumnLayout;
var serialcolumnLayout =[{dataField:"rnum"         ,headerText:"RowNum"                      ,width:120    ,height:30 , visible:false},
                         {dataField:"status"       ,headerText:"Status"                      ,width:120    ,height:30 , visible:false},
                         {dataField:"reqstno"      ,headerText:"Stock Movement Request"      ,width:"20%"    ,height:30   ,cellMerge : true            },
                         {dataField:"staname"      ,headerText:"Status"                      ,width:120    ,height:30 , visible:false                },
                         {dataField:"reqitmno"     ,headerText:"Stock Movement Request Item" ,width:120    ,height:30 , visible:false},
                         {dataField:"ttype"        ,headerText:"Transaction Type"            ,width:120    ,height:30 , visible:false},
                         {dataField:"ttext"        ,headerText:"Transaction Type Text"       ,width:120    ,height:30   , visible:false              },
                         {dataField:"mtype"        ,headerText:"Movement Type"               ,width:120    ,height:30 , visible:false},
                         {dataField:"mtext"        ,headerText:"Movement Text"               ,width:120    ,height:30  , visible:false               },
                         {dataField:"froncy"       ,headerText:"Auto / Manual"               ,width:120    ,height:30  , visible:false               },
                         {dataField:"crtdt"        ,headerText:"Request Create Date"         ,width:120    ,height:30    , visible:false             },
                         {dataField:"reqdate"      ,headerText:"Request Required Date"       ,width:120    ,height:30   , visible:false              },
                         {dataField:"rcvloc"       ,headerText:"From Location"               ,width:120    ,height:30 , visible:false},
                         {dataField:"rcvlocnm"     ,headerText:"From Location"               ,width:120    ,height:30 , visible:false},
                         {dataField:"rcvlocdesc"   ,headerText:"From Location"               ,width:120    ,height:30     , visible:false            },
                         {dataField:"reqloc"       ,headerText:"To Location"                 ,width:120    ,height:30 , visible:false},
                         {dataField:"reqlocnm"     ,headerText:"To Location"                 ,width:120    ,height:30 , visible:false},
                         {dataField:"reqlocdesc"   ,headerText:"To Location"                 ,width:120    ,height:30     , visible:false            },
                         {dataField:"itmcd"        ,headerText:"Material Code"               ,width:"20%"    ,height:30 ,cellMerge : true  },
                         {dataField:"itmname"      ,headerText:"Material Name"               ,width:"25%"    ,height:30 ,cellMerge : true                 },
                         {dataField:"num"     ,headerText:"Seq."                 ,width:"5%"    ,height:30   ,style :"aui-grid-user-custom-right"          },
                         {dataField:"reqstqty"     ,headerText:"Requested Qty"                 ,width:120    ,height:30   , visible:false              },
                         {dataField:"rmqty"        ,headerText:"Remain Qty"                 ,width:120    ,height:30    , visible:false             },
                         {dataField:"delvno"       ,headerText:"delvno"                      ,width:120    ,height:30 , visible:false},
                         {dataField:"delyqty"      ,headerText:"delvno"                      ,width:120    ,height:30 , visible:false},
                         {dataField:"indelyqty"      ,headerText:"Delivered Qty"                ,width:120    ,height:30 , editable:true 
                             ,dataType : "numeric" ,editRenderer : {
                                 type : "InputEditRenderer",
                                 onlyNumeric : true, // 0~9 까지만 허용
                                 allowPoint : false // onlyNumeric 인 경우 소수점(.) 도 허용
                           } , visible:false
                         },
                         {dataField:"greceipt"     ,headerText:"Good Receipted"                ,width:120    ,height:30     , visible:false            },
                         {dataField:"uom"          ,headerText:"Unit of Measure"             ,width:120    ,height:30 , visible:false},
                         {dataField:"uomnm"        ,headerText:"Unit of Measure"             ,width:120    ,height:30  , visible:false              },
                         {dataField:"serial"      ,headerText:"Serial"    ,width:"30%"    ,height:30,editable:true,
                        	 editRenderer : {
                        		    type : "InputEditRenderer",
                        		    showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                        		    onlyNumeric : false, // 0~9만 입력가능
                        		    allowPoint : false, // 소수점( . ) 도 허용할지 여부
                        		    allowNegative : false, // 마이너스 부호(-) 허용 여부
                        		    textAlign : "center", // 오른쪽 정렬로 입력되도록 설정
                        		    autoThousandSeparator : false // 천단위 구분자 삽입 여부
                        		}	 
                         } 
                        ];
var serialcolumn       =[{dataField:"itmcd"        ,headerText:"Material Code"               ,width:"20%"    ,height:30 },
                         {dataField:"itmname"      ,headerText:"Material Name"               ,width:"25%"    ,height:30 },
                         {dataField:"serial"       ,headerText:"Serial"                      ,width:"30%"    ,height:30,editable:true },
                         {dataField:"cnt61"        ,headerText:"Serial"                      ,width:"30%"    ,height:30,visible:false },
                         {dataField:"cnt62"        ,headerText:"Serial"                      ,width:"30%"    ,height:30,visible:false },
                         {dataField:"cnt63"        ,headerText:"Serial"                      ,width:"30%"    ,height:30,visible:false },
                         {dataField:"statustype"   ,headerText:"status"                      ,width:"30%"    ,height:30,visible:false }
                        ];                        

//var resop = {usePaging : true,useGroupingPanel : true , groupingFields : ["reqstno"] ,displayTreeOpen : true, enableCellMerge : true, showBranchOnGrouping : false};
var resop = {
		rowIdField : "rnum",
		fixedColumnCount : 9,
		editable : true,
		groupingFields : ["reqstno", "staname"],
        displayTreeOpen : true,
        showRowCheckColumn : true ,
        enableCellMerge : true,
        showStateColumn : false,
        showBranchOnGrouping : false
        };
var serialop = {
		//rowIdField : "rnum",			
		editable : true
        //displayTreeOpen : true,
        //showRowCheckColumn : true ,
        //enableCellMerge : true,
        //showStateColumn : false,
        //showBranchOnGrouping : false
        };

var paramdata;

var amdata = [{"codeId": "A","codeName": "Auto"},{"codeId": "M","codeName": "Manaual"}];
var uomlist = f_getTtype('42' , '');
var paramdata;
$(document).ready(function(){
	/**********************************
    * Header Setting
    **********************************/
    
    //paramdata = { groupCode : '306' , orderValue : 'CRT_DT' , likeValue:''};
	paramdata = { groupCode : '306' , orderValue : 'CRT_DT' , notlike:'US'};
    //doGetComboData('/common/selectCodeList.do', paramdata, '${searchVal.sttype}','sttype', 'S' , 'f_change');
    doGetComboData('/common/selectCodeList.do', paramdata, ('${searchVal.sttype}'==''?'UM':'${searchVal.sttype}'),'sttype', 'S' , 'f_change');
    doGetComboData('/common/selectCodeList.do', {groupCode:'309'}, '${searchVal.sstatus}','sstatus', 'S' , '');
    doGetComboData('/logistics/stockMovement/selectStockMovementNo.do', {groupCode:'stock'} , '${searchVal.streq}','streq', 'S' , '');
//     doGetCombo('/common/selectStockLocationList.do', '', '${searchVal.tlocation}','tlocation', 'S' , '');
//     doGetCombo('/common/selectStockLocationList.do', '', '${searchVal.flocation}','flocation', 'S' , 'SearchListAjax');
    //doDefCombo(amdata, '${searchVal.sam}' ,'sam', 'S', '');
    $("#crtsdt").val('${searchVal.crtsdt}');
    $("#crtedt").val('${searchVal.crtedt}');
    $("#reqsdt").val('${searchVal.reqsdt}');
    $("#reqedt").val('${searchVal.reqedt}');
    
    /**********************************
     * Header Setting End
     ***********************************/
    
    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, resop);
    serialGrid = AUIGrid.create("#serial_grid_wrap", serialcolumn, serialop);
    
    
    AUIGrid.bind(listGrid, "cellClick", function( event ) {});
    
    AUIGrid.bind(listGrid, "cellEditBegin", function (event){
    	
    	if (event.dataField != "indelyqty"){
    		return false;
    	}else{
    	    var checklist = AUIGrid.getCheckedRowItemsAll(listGrid);
            for(var i = 0 ; i < checklist.length ; i++){
                if (checklist[i].reqstno != event.item.reqstno){
                	Common.alert("Request number is different.");
                    return false;
                }
            }
            
    	    if (AUIGrid.getCellValue(listGrid, event.rowIndex, "rmqty") <= 0){
    	    	Common.alert('Delivery Qty can not be greater than Request Qty.');
    	    	return false;
    	    }
    	}
    });
    
    AUIGrid.bind(listGrid, "cellEditEnd", function (event){
        
        if (event.dataField != "indelyqty"){
            return false;
        }else{
        	
        	var del = AUIGrid.getCellValue(listGrid, event.rowIndex, "indelyqty");
        	if (del > 0){
	        	if ((Number(AUIGrid.getCellValue(listGrid, event.rowIndex, "rmqty")) < Number(AUIGrid.getCellValue(listGrid, event.rowIndex, "indelyqty"))) 
	        		||(Number(AUIGrid.getCellValue(listGrid, event.rowIndex, "rmqty")) < Number(AUIGrid.getCellValue(listGrid, event.rowIndex, "indelyqty")))){
	        		Common.alert('Delivery Qty can not be greater than Request Qty.');
	        		//AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstqty")
	        		AUIGrid.restoreEditedRows(listGrid, "selectedIndex");
	        	}else{
	        		
	        		AUIGrid.addCheckedRowsByIds(listGrid, event.item.rnum);
	        	}
        	}else{
        		AUIGrid.restoreEditedRows(listGrid, "selectedIndex");
        		AUIGrid.addUncheckedRowsByIds(listGrid, event.item.rnum);        		
        	}
        	
        	
        }
    });
    AUIGrid.bind(serialGrid, "cellEditEnd", function (event){
    	var tvalue = true;
       var serial = AUIGrid.getCellValue(serialGrid, event.rowIndex, "serial");
       serial=serial.trim();
       if(""==serial || null ==serial){
          //alert(" ( " + event.rowIndex + ", " + event.columnIndex + ") : clicked!!");
          //AUIGrid.setSelectionByIndex(serialGrid,event.rowIndex, event.columnIndex);
	       Common.alert('Please input Serial Number.');
	       return false;
       }else{
    	   for (var i = 0 ; i < AUIGrid.getRowCount(serialGrid) ; i++){
    		   if (event.rowIndex != i){
    			   if (serial == AUIGrid.getCellValue(serialGrid, i, "serial")){
    				   tvalue = false;
    				   break;
    			   }
    		   }
    	   }
    	   
    	   if (tvalue){
    		   fn_serialChck(event.rowIndex ,event.item , serial)
    	   }else{
    		   AUIGrid.setCellValue(serialGrid , event.rowIndex , "statustype" , 'N' );
               AUIGrid.setProp(serialGrid, "rowStyleFunction", function(rowIndex, item) {
                   if (item.statustype  == 'N'){
                       return "my-row-style";
                   }
               });
               AUIGrid.update(serialGrid);
    	   }
    	  
       	  if($("#serialqty").val() > AUIGrid.getRowCount(serialGrid)){
             f_addrow();      
          }
          
       }
    });
    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){
//      	$("#rStcode").val(AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstno"));

//     	document.searchForm.action = '/logistics/stocktransfer/StocktransferView.do';
//     	document.searchForm.submit();
    });
    
    AUIGrid.bind(listGrid, "rowCheckClick", function(event){
    	
    	var checklist = AUIGrid.getCheckedRowItemsAll(listGrid);
        for(var i = 0 ; i < checklist.length ; i++){
            if (checklist[i].reqstno != event.item.reqstno){
                Common.alert("Request number is different.");
                AUIGrid.addUncheckedRowsByIds(listGrid, event.item.rnum);
                return false;
            }
        }
        
    	if (AUIGrid.getCellValue(listGrid, event.rowIndex, "rmqty") <= 0 || AUIGrid.getCellValue(listGrid, event.rowIndex, "rmqty") < AUIGrid.getCellValue(listGrid, event.rowIndex, "indelyqty")){
            Common.alert('Delivery Qty can not be greater than Request Qty.');
            AUIGrid.addUncheckedRowsByIds(listGrid, event.item.rnum);
            return false;
        }
    	
    });
    
     AUIGrid.bind(serialGrid, "addRowFinish", function(event) {
    	 AUIGrid.setSelectionByIndex(serialGrid, AUIGrid.getRowCount(serialGrid) - 1, 2);
     });
     
     /*AUIGrid.bind(serialGrid, "keyDown", function(event){
    	 
    	 if (event.keyCode == 13){
    		 f_addrow();
    	 }
     });*/
    
    AUIGrid.bind(listGrid, "ready", function(event) {
    	var rowCnt = AUIGrid.getRowCount(listGrid);
    	for (var i = 0 ; i < rowCnt ; i++){
    		var qty = AUIGrid.getCellValue(listGrid , i , 'reqstqty') - AUIGrid.getCellValue(listGrid , i , 'delyqty');
    		AUIGrid.setCellValue(listGrid, i, 'rmqty', qty);
    	}
    	AUIGrid.resetUpdatedItems(listGrid, "all");
    });
    
});
function f_change(){
	paramdata = { groupCode : '308' , orderValue : 'CODE_NAME' , likeValue:$("#sttype").val()};
    doGetComboData('/common/selectCodeList.do', paramdata, '${searchVal.smtype}','smtype', 'S' , '');
}
//btn clickevent
$(function(){
    $('#search').click(function() {
    	SearchListAjax();
    });
    $("#sttype").change(function(){
    	
        paramdata = { groupCode : '308' , orderValue : 'CODE_NAME' , likeValue:$("#sttype").val()};
        doGetComboData('/common/selectCodeList.do', paramdata, '${searchVal.smtype}','smtype', 'S' , '');
    });
    $('#delivery').click(function(){
    	var checkDelqty= false; 
    	var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
        if(checkedItems.length <= 0) {
            Common.alert('No data selected.');
            return false;
        }else{
            var checkedItems = AUIGrid.getCheckedRowItems(listGrid);
            var str = "";
            var rowItem;
            for(var i=0, len = checkedItems.length; i<len; i++) {
                rowItem = checkedItems[i];
                if(rowItem.item.indelyqty==0){
                str += "Please Check Delivery Qty of  " + rowItem.item.reqstno   + ", " + rowItem.item.itmname + "<br />";
                checkDelqty= true;
                }
            }
            if(checkDelqty){
            	var option = {
           			content : str,
           			isBig:true
            	};
	            Common.alertBase(option); 
            }else{
	            $("#giopenwindow").show();
	            $("#giptdate").val("");
	            $("#gipfdate").val("");
	            $("#doctext").val("");
	            doSysdate(0 , 'giptdate');
	            doSysdate(0 , 'gipfdate');
	            AUIGrid.clearGridData(serialGrid);
	            AUIGrid.resize(serialGrid); 
	            //fn_itempopList(checkedItems);
	            fn_itempopList_T(checkedItems);
            }
        }
    	
    });
});

function SearchListAjax() {
   
    var url = "/logistics/stockMovement/StockMovementSearchList.do";
    var param = $('#searchForm').serializeJSON();
    Common.ajax("POST" , url , param , function(data){
        AUIGrid.setGridData(listGrid, data.data);
    });
}

function f_getTtype(g , v){
    var rData = new Array();
    $.ajax({
           type : "GET",
           url : "/common/selectCodeList.do",
           data : { groupCode : g , orderValue : 'CRT_DT' , likeValue:v},
           dataType : "json",
           contentType : "application/json;charset=UTF-8",
           async:false,
           success : function(data) {
              $.each(data, function(index,value) {
                  var list = new Object();
                  list.code = data[index].code;
                  list.codeId = data[index].codeId;
                  list.codeName = data[index].codeName;
                  rData.push(list);
                });
           },
           error: function(jqXHR, textStatus, errorThrown){
               alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
           },
           complete: function(){
           }
       });
    
    return rData;
}


function fn_itempopList(data){
    var rowPos = "first";
    var rowList = [];
    var str = "";
    var rowItem;
    var cnt=0;
    for(var i=0, len = data.length; i<len; i++) {
        rowItem = data[i];
         var num=1;
                
        
        for (var j = 0 ; j < rowItem.item.indelyqty ; j++){
        rowList[cnt] = {
                rnum : rowItem.item.rnum,
                reqstno : rowItem.item.reqstno,
                itmcd : rowItem.item.itmcd,
                itmname : rowItem.item.itmname,
                num : num,
                indelyqty : rowItem.item.indelyqty,
                serial : num
        }       
                 
                cnt++;
                num++;
        }
    }
    AUIGrid.addRow(serialGrid, rowList, rowPos);
    
    
}

function fn_itempopList_T(data){
	
	var itm_temp = "";
	var itm_qty  = 0;
	var itmdata = [];
	for (var i = 0 ; i < data.length ; i++){
		itm_qty = itm_qty + data[i].item.indelyqty;
		$("#reqstno").val(data[i].item.reqstno)
	}
	$("#serialqty").val(itm_qty);
	
	
	f_addrow();
}

function f_addrow(){
	var rowPos = "last";
    var item = new Object();
    AUIGrid.addRow(serialGrid, item, rowPos);
    return false;
}

function giFunc(){
    var data = {};
    var checkdata = AUIGrid.getCheckedRowItemsAll(listGrid);
    var check     = AUIGrid.getCheckedRowItems(listGrid);
    var serials     = AUIGrid.getAddedRowItems(serialGrid);
    
    for (var i = 0 ; i < AUIGrid.getRowCount(serialGrid) ; i++){
    	if (AUIGrid.getCellValue(serialGrid , i , "statustype") == 'N'){
    		Common.alert("Please check the serial.")
    		return false;
    	}
    	
    	if (AUIGrid.getCellValue(serialGrid , i , "serial") == undefined || AUIGrid.getCellValue(serialGrid , i , "serial") == "undefined"){
    		Common.alert("Please check the serial.")
            return false;
    	}
    }
    
    if ($("#serialqty").val() != AUIGrid.getRowCount(serialGrid)){
    	Common.alert("Please check the serial.")
        return false;
    }
    
    data.check   = check;
    data.checked = check;
    data.add = serials;
    data.form    = $("#giForm").serializeJSON();
    
    Common.ajax("POST", "/logistics/stockMovement/StockMovementReqDelivery.do", data, function(result) {
       
            Common.alert(result.message , SearchListAjax);
            AUIGrid.resetUpdatedItems(listGrid, "all");    
        $("#giopenwindow").hide();
        $('#search').click();

    },  function(jqXHR, textStatus, errorThrown) {
        try {
        } catch (e) {
        }
        Common.alert("Fail : " + jqXHR.responseJSON.message);
    });
        for (var i = 0 ; i < checkdata.length ; i++){
            AUIGrid.addUncheckedRowsByIds(listGrid, checkdata[i].rnum);
        }
}

function fn_serialChck(rowindex , rowitem , str){
	var schk = true;
	var ichk = true;
	var slocid = '';//session.locid;
    var data = { serial : str , locid : slocid};
    Common.ajaxSync("GET", "/logistics/stockMovement/StockMovementSerialCheck.do", data, function(result) {
    	if (result.data[0] == null){
    		AUIGrid.setCellValue(serialGrid , rowindex , "itmcd" , "" );
            AUIGrid.setCellValue(serialGrid , rowindex , "itmname" , "" );
            AUIGrid.setCellValue(serialGrid , rowindex , "cnt61" , 0 );
            AUIGrid.setCellValue(serialGrid , rowindex , "cnt62" , 0 );
            AUIGrid.setCellValue(serialGrid , rowindex , "cnt63" , 0 );
            
            schk = false;
            ichk = false;
            
    	}else{
	         AUIGrid.setCellValue(serialGrid , rowindex , "itmcd" , result.data[0].STKCODE );
	         AUIGrid.setCellValue(serialGrid , rowindex , "itmname" , result.data[0].STKDESC );
	         AUIGrid.setCellValue(serialGrid , rowindex , "cnt61" , result.data[0].L61CNT );
	         AUIGrid.setCellValue(serialGrid , rowindex , "cnt62" , result.data[0].L62CNT );
	         AUIGrid.setCellValue(serialGrid , rowindex , "cnt63" , result.data[0].L63CNT );
	         
	         if (result.data[0].L61CNT > 0 || result.data[0].L62CNT == 0 || result.data[0].L63CNT > 0){
	        	 schk = false;
	         }else{
	        	 schk = true;
	         }
	         
	         var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
	         
	         for (var i = 0 ; i < checkedItems.length ; i++){
	             if (result.data[0].STKCODE == checkedItems[i].itmcd){
	                 //AUIGrid.setCellValue(serialGrid , rowindex , "statustype" , 'Y' );
	                 ichk = true;
	                 break;
	             }else{
	                 ichk = false;
	             }
	         }
    	}
         
         if (schk && ichk){
        	 AUIGrid.setCellValue(serialGrid , rowindex , "statustype" , 'Y' );
         }else{
        	 AUIGrid.setCellValue(serialGrid , rowindex , "statustype" , 'N' );
         }
          
       	  //Common.alert("Input Serial Number does't exist. <br /> Please inquire a person in charge. " , function(){AUIGrid.setSelectionByIndex(serialGrid, AUIGrid.getRowCount(serialGrid) - 1, 2);});
       	  AUIGrid.setProp(serialGrid, "rowStyleFunction", function(rowIndex, item) {
       		  
       		  if (item.statustype  == 'N'){
       			  return "my-row-style";
       		  }
       	  });
       	  AUIGrid.update(serialGrid);
        	 
    },  function(jqXHR, textStatus, errorThrown) {
        try {
        } catch (e) {
        }
        Common.alert("Fail : " + jqXHR.responseJSON.message);
       
    });
}
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>Stock Movement Delivery</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>New-Stock Movement Request List For Delivery</h2>
</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
    <ul class="right_btns">
            <li><p class="btn_gray"><a id="clear"><span class="clear"></span>Clear</a></p></li>
            <li><p class="btn_gray"><a id="search"><span class="search"></span>Search</a></p></li>
        </ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
    <form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
        <input type="hidden" name="rStcode" id="rStcode" />    
        <table summary="search table" class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:160px" />
                <col style="width:*" />
                <col style="width:160px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row">Stock Movement Request</th>
                    <td>
                        <select class="w100p" id="streq" name="streq"></select>
                    </td>
                    <th scope="row">Stock Movement Type</th>
                    <td>
                        <select class="w100p" id="sttype" name="sttype"></select>
                    </td>
                    <th scope="row">Movement Type</th>
                    <td>
                        <select class="w100p" id="smtype" name="smtype"><option value=''>Choose One</option></select>
                    </td>
                </tr>
                <tr>
                    <th scope="row">From Location</th>
                    <td>
                        <select class="w100p" id="tlocation" name="tlocation"></select>
                    </td>
                    <th scope="row">To Location</th>
                    <td >
                        <select class="w100p" id="flocation" name="flocation"></select>
                    </td>
                    <td colspan="2">&nbsp;</td>                
                </tr>
                
                <tr>
                    <th scope="row">Create Date</th>
                    <td>
                        <div class="date_set"><!-- date_set start -->
					    <p><input id="crtsdt" name="crtsdt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"></p>   
					    <span> ~ </span>
					    <p><input id="crtedt" name="crtedt" type="text" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date"></p>
					    </div><!-- date_set end -->                        
                    </td>
                    <th scope="row">Required Date</th>
                    <td >
                        <div class="date_set"><!-- date_set start -->
                        <p><input id="reqsdt" name="reqsdt" type="text" title="Create start Date" value="${searchVal.reqsdt}" placeholder="DD/MM/YYYY" class="j_date"></p>   
                        <span> ~ </span>
                        <p><input id="reqedt" name="reqedt" type="text" title="Create End Date" value="${searchVal.reqedt}" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    </td>
                    <td colspan="2">&nbsp;</td>                
                </tr>
                
                <tr>
                    <th scope="row">Status</th>
                    <td>
                        <select class="w100p" id="sstatus" name="sstatus"></select>
                    </td>
                    <th scope="row">Auto / Manual</th>
                    <td>
                        <!-- <select class="w100p" id="sam" name="sam"></select> -->
                    </td>
                    <td colspan="2">&nbsp;</td>              
                </tr>
            </tbody>
        </table><!-- table end -->        
    </form>

    </section><!-- search_table end -->

    <!-- data body start -->
   <section class="search_result"><!-- search_result start -->
        <ul class="right_btns">
            <li><p class="btn_grid"><a id="delivery"><span class="search"></span>DELIVERY</a></p></li>                        
        </ul>

        <div id="main_grid_wrap" class="mt10" style="height:350px"></div>

    </section><!-- search_result end -->
    
    <div class="popup_wrap" id="giopenwindow" style="display:none"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
            <h1>Serial Check</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
            </ul>
        </header><!-- pop_header end -->
        
        <section class="pop_body"><!-- pop_body start -->
            <form id="giForm" name="giForm" method="POST">
            <input type="hidden" name="gtype" id="gtype" value="GI"/>
            <input type="hidden" name="serialqty" id="serialqty"/>
            <input type="hidden" name="reqstno" id="reqstno"/>
            <table class="type1">
            <caption>search table</caption>
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:150px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row">GI Posting Date</th>
                    <td ><input id="giptdate" name="giptdate" type="text" title="Create start Date" value="" readonly/></td>    
                    <th scope="row">GI Doc Date</th>
                    <td ><input id="gipfdate" name="gipfdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" /></td>    
                </tr>
                <tr>    
                    <th scope="row">Header Text</th>
                    <td colspan='3'><input type="text" name="doctext" id="doctext" class="w100p"/></td>
                </tr>
            </tbody>
            </table>
            <table class="type1">
            <caption>search table</caption>
            <colgroup id="serialcolgroup">
            </colgroup>
            <tbody id="dBody">
            </tbody>
            </table>
            <article class="grid_wrap"><!-- grid_wrap start -->
			<div id="serial_grid_wrap" class="mt10" style="width:100%;"></div>
			</article><!-- grid_wrap end -->
            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a onclick="javascript:giFunc();">SAVE</a></p></li>
            </ul>
            </form>
        
        </section>
    </div>
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
</section>

