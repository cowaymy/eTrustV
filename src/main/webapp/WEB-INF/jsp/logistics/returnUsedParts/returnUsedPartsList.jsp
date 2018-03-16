<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
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

</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var listGrid;
var subGrid;
var userCode;
var comboData = [{"codeId": "N","codeName": "Not yet"},{"codeId": "Y","codeName": "Done"}];
var comboData1 = [{"codeId": "62","codeName": "Filter"},{"codeId": "63","codeName": "Spare Part"}];
var comboData2 = [{"codeId": "03","codeName": "CT"},{"codeId": "04","codeName": "CODY"}];
var comboData3 = [{"codeId": "A","codeName": "A"},{"codeId": "B","codeName": "B"}];
var uomlist = f_getTtype('364' , ''); 
var oldQty;
var oldSerial;


/* Required Date 초기화 */
var today = new Date();
today.setDate(today.getDate() -7); 
var dd = today.getDate();
var mm = today.getMonth()+1;
var yyyy = today.getFullYear();

if(dd<10) { dd='0'+dd; }

if(mm<10) { mm='0'+mm; }

today = (dd + '/' + mm + '/' + yyyy);

// var nextDate = new Date();
// nextDate.setDate(nextDate.getDate() +6);
// var dd2 = nextDate.getDate();
// var mm2 = nextDate.getMonth() + 1;
// var yyyy2 = nextDate.getFullYear();

// if(dd2 < 10) { dd2 = '0' + dd2; }

// if(mm2 < 10) { mm2 ='0' + mm2; }

// nextDate = (dd2 + '/' + mm2 + '/' + yyyy2);


                      
var rescolumnLayout=[{dataField:    "rnum",headerText :"<spring:message code='log.head.rownum'/>"               ,width:120    ,height:30 , visible:false},        
                     {dataField: "seq",headerText :"seq"      ,width:120    ,height:30, visible:false },  
                     {dataField: "serviceOrder",headerText :"<spring:message code='log.head.serviceorder'/>"      ,width:120    ,height:30, editable:false },                        
                     {dataField: "customer",headerText :"<spring:message code='log.head.customer'/>"      ,width:120    ,height:30, editable:false },                        
                     {dataField: "customerName",headerText :"<spring:message code='log.head.customername'/>"           ,width:120    ,height:30, editable:false },                       
                     {dataField: "serviceDate",headerText :"<spring:message code='log.head.servicedate'/>"                 ,width:120    ,height:30, editable:false},                        
                     {dataField: "materialCode",headerText :"<spring:message code='log.head.materialcode'/>"           ,width:120    ,height:30, editable:true},    
//                      {dataField: "materialCodeActual",headerText :"Material Code Actual"           ,width:150    ,height:30, editable:true},
//                      {dataField: "stkIdNew",headerText :"New STK_ID"           ,width:150    ,height:30, editable:true},
                     {dataField: "materialName",headerText :"<spring:message code='log.head.materialname'/>"     ,width:120    ,height:30, editable:false},                          
                     {dataField: "serialNumber",headerText :"<spring:message code='log.head.serialnumber(system)'/>"                ,width:120    ,height:30, editable:true},                       
//                      {dataField: "serial",headerText :"<spring:message code='log.head.serial(actual)'/>"     ,width:120    ,height:30                },     
                     {dataField: "qty",headerText :"<spring:message code='log.head.qty'/>"          ,width:120    ,height:30                },                       
                     /* {dataField:  "noPartsReturn",headerText :"<spring:message code='log.head.nopartsreturn'/>"        ,width:120    ,height:30 },  */                        
                     {dataField: "noPartsReturn",headerText :"<spring:message code='log.head.nopartsreturn'/>"               ,width:120    ,height:30 
                          ,labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {
                              var retStr = "";
                              
                              for(var i=0,len=uomlist.length; i<len; i++) {
                                  if(uomlist[i]["code"] == value) {
                                      retStr = uomlist[i]["codeName"];
                                      break;
                                  }
                              }
                              return retStr == "" ? value : retStr;
                          },editRenderer : 
                          {
                             type : "ComboBoxRenderer",
                             showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                             list : uomlist,
                             keyField : "code", 
                             valueField : "codeName"
                          }
                      },
                      {dataField: "text",headerText :"<spring:message code='log.head.text'/>"      ,width:120    ,height:30                },                         
                      {dataField: "returnComplete",headerText :"<spring:message code='log.head.returncomplete'/>"      ,width:120    ,height:30, editable:false},                         
                      {dataField: "returnCompleteDate",headerText :"<spring:message code='log.head.returncompletedate'/>"      ,width:120    ,height:30, editable:false},                         
                      {dataField: "serialChk",headerText :"<spring:message code='log.head.serialchk'/>"        ,width:120    ,height:30, editable:false}  
                      ];                     
 
var subgridpros = {
        // 페이지 설정
        rowIdField : "rnum",
        usePaging : false,                   
        editable : true,                
        noDataMessage : "<spring:message code='sys.info.grid.noDataMessage'/>",
        //enableSorting : true,
        //selectionMode : "multipleRows",
        //selectionMode : "multipleCells",
        useGroupingPanel : true,
        // 체크박스 표시 설정
        showRowCheckColumn : true,
        // 전체 체크박스 표시 설정
        showRowAllCheckBox : true,
        showFooter : false,
        //softRemoveRowMode:false
        rowCheckableFunction : function(rowIndex, isChecked, item) {
        	oldQty=item.qty;
        	oldSerial=item.serial;
            var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
            
            for (var i = 0; i < checkedItems.length; i++) {
//             	oldQty=checkedItems[i].qty;
//             	alert("oldQty?? : "+oldQty);
            	if(i != rowIndex){
            		AUIGrid.addUncheckedRowsByIds(listGrid, checkedItems[i].rnum);  
            	}else{
            		AUIGrid.addUncheckedRowsByIds(listGrid, checkedItems[i].rnum);           		
            	}
            		
			}
                             
         },
        
        };
       
var paramdata;

$(document).ready(function(){
    
    /**********************************
    * Header Setting
    **********************************/
    doDefCombo(comboData1, '' ,'searchMaterialType', 'S', '');
    doDefCombo(comboData, '' ,'searchComplete', 'S', '');
    doDefCombo(comboData2, '' ,'searchlocgb', 'S', '');
    
    
    doGetComboData('/logistics/totalstock/selectTotalBranchList.do','', '', 'searchBranch', 'S','');
    //doGetComboData('/common/selectCodeList.do', { groupCode : 383 , orderValue : 'CODE' , Codeval : 'A'}, '', 'searchlocgrade', 'S','');
   // doGetComboData('/common/selectCodeList.do', { groupCode : 339 , orderValue : 'CODE'}, '', 'searchlocgb', 'M','f_multiCombo');
   $("#servicesdt").val(today);
    doSysdate(0 , 'serviceedt');  
    doDefCombo(comboData3, 'A' ,'searchlocgrade', 'S', '');
    

    
    
    
    /**********************************
     * Header Setting End
     ***********************************/
    
    listGrid = AUIGrid.create("#main_grid_wrap", rescolumnLayout, subgridpros);    
      
    AUIGrid.bind(listGrid, "cellClick", function( event ) {

    });
    
    AUIGrid.bind(listGrid, "cellDoubleClick", function(event){

    });
    
    AUIGrid.bind(listGrid, "ready", function(event) {
    });
    
    
    AUIGrid.bind(listGrid, "cellEditEnd", function (event){
      var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
         if(checkedItems.length <= 0) {
             Common.alert('No data selected.');
             $("#search").click();
          
             return false;
         }else{
        	 
         if(event.dataField == "materialCode"){	 
          var matcode = AUIGrid.getCellValue(listGrid, event.rowIndex, "materialCode") ;
          
          if(matcode.length > 15){
        	  Common.alert('matcode is greater than 15 characters.');
        	  AUIGrid.setCellValue(listGrid , event.rowIndex , "materialCode" , "" );
        	  return false;
          }
            
          var indexnum =event.rowIndex;
          validMatCodeAjax(matcode,indexnum);

         }

          

//         if(event.dataField == "serial"){
//             if(AUIGrid.getCellValue(listGrid, event.rowIndex, "serialChk") =="Y"){
//                 AUIGrid.setCellValue(listGrid, event.rowIndex, "qty", 1);
//                 return false;
//             }
            
//             if(AUIGrid.getCellValue(listGrid, event.rowIndex, "serialChk") !="Y"){
//             	Common.alert("No Enter Serial");
//             	AUIGrid.setCellValue(listGrid, event.rowIndex, "serial", "");
//                 return false;
//             }            
            
//         }
//         if(event.dataField == "qty"){
//         	if(AUIGrid.getCellValue(listGrid, event.rowIndex, "serialChk") !="Y"){
//         		if(AUIGrid.getCellValue(listGrid, event.rowIndex, "qty") >  oldQty){
//         			Common.alert('The requested quantity is up to '+oldQty+'.');
//         			AUIGrid.setCellValue(listGrid, event.rowIndex, "qty", oldQty);
//         			return false;
//         			 }        		
//         		 }        	
//         	 if(AUIGrid.getCellValue(listGrid, event.rowIndex, "serialChk") =="Y"){
//                  if(AUIGrid.getCellValue(listGrid, event.rowIndex, "qty") >  1){
//                      Common.alert('only qty count 1.');
//                      AUIGrid.setCellValue(listGrid, event.rowIndex, "qty", 1);  
//                      return false;
//                       }              
//                   }       
//         	    }
         }
        
    });
    
});



	$(function() {
	
	$('#search').click(function() {
		
			SearchListAjax();

		});
		$('#clear').click(function() {

			testFunc();

		});//insert
		
		$('#delete').click(function() {

			deltestFunc();

        });//delete

		$('#complete').click(function() {
			 var chkfalg; 
			 var allChecked = false
			 var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
		        if(checkedItems.length <= 0) {
		            Common.alert('No data selected.');
		            return false;
		        }else{
		       if(checkedItems.length <= 1){
	        	   for (var i = 0 ; i < checkedItems.length ; i++){
	                  // if (checkedItems[i].serialChk == 'Y' && checkedItems[i].serial =="" || checkedItems[i].serial == undefined){
	                   //if (checkedItems[i].serialNumber =="" || checkedItems[i].serialNumber == undefined){
	                	//   Common.alert("Please Enter Serial");
	                    //   chkfalg="Y";
	                   //    break;
	                  // }else{
	                  if (checkedItems[i].returnComplete =="Y"){
	                	  chkfalg="Y";
	                	  Common.alert('Already processed.');
	                  }else{
	                	   chkfalg="N";     	  
	                  }

	                 //  }   
	                   
	                   if (checkedItems[i].materialCode =="" || checkedItems[i].materialCode == undefined){
	                	   Common.alert("Please Enter materialCode");
	                	   return false;
	                   }
	                 } 	        	   
	        	   }else{
	        		   Common.alert("only one data selected.");
	        		    AUIGrid.setAllCheckedRows(listGrid, allChecked);
	        	   }
		        }       
		        if(chkfalg=="N"){
		        if(f_validatation('save')){
		        	upReturnParts();		        		
		        	}
		        //업데이트 쿼리 	
		        }		        
		});
        
        $("#download").click(function() {
        	GridCommon.exportTo("main_grid_wrap", 'xlsx', "Return Used Parts List")
        });
		
	$('#cancle').click(function() {
		
		cancleReturnParts();

		});
	
    $('#searchBranch').change(function(){
    	if ($('#searchBranch').val() != null && $('#searchBranch').val() != "" ){	
        var searchlocgb = $('#searchlocgb').val();
        var searchBranch = $('#searchBranch').val();
        //alert("searchBranch :  "+searchBranch);
//         var locgbparam = "";
//         for (var i = 0 ; i < searchlocgb.length ; i++){
//             if (locgbparam == ""){
//                 locgbparam = searchlocgb[i];
//             }else{
//                 locgbparam = searchlocgb[i];
//             }
//         }
        //alert("searchlocgb :  "+searchlocgb);
        if ($('#searchlocgb').val() == null || $('#searchlocgb').val() == "" ){   
        	Common.alert("Please select Location Type");
        	doGetComboData('/logistics/totalstock/selectTotalBranchList.do','', '', 'searchBranch', 'S','');
        	return false;
        }

        var param = {searchlocgb:searchlocgb , grade:$('#searchlocgrade').val() , searchBranch:searchBranch     }
        doGetComboData('/common/selectStockLocationList3.do', param , '', 'searchLoc', 'M','f_multiComboType');
    	}
    	
    });
	
	
	
    $('#searchlocgrade').change(function(){
        var searchlocgb = $('#searchlocgb').val();

//         var locgbparam = "";
//         for (var i = 0 ; i < searchlocgb.length ; i++){
//             if (locgbparam == ""){
//                 locgbparam = searchlocgb[i];
//             }else{
//                 locgbparam = searchlocgb[i];
//             }
//         }

        var param = {searchlocgb:searchlocgb , grade:$('#searchlocgrade').val()}
        doGetComboData('/common/selectStockLocationList2.do', param , '', 'searchLoc', 'M','f_multiComboType');
    });
	
	
    $('#searchlocgb').change(function() {
        console.log('1');
        if ($('#searchlocgb').val() != null && $('#searchlocgb').val() != "" ){
             var searchlocgb = $('#searchlocgb').val();
             //alert("searchlocgb :  "+searchlocgb);

//                 var locgbparam = "";
//                 for (var i = 0 ; i < searchlocgb.length ; i++){
//                     if (locgbparam == ""){
//                         locgbparam = searchlocgb[i];
//                     }else{
//                         locgbparam = searchlocgb[i];
//                     }
//                 }
                var param = {searchlocgb:searchlocgb , grade:$('#searchlocgrade').val()}
                doGetComboData('/common/selectStockLocationList2.do', param , '', 'searchLoc', 'M','f_multiComboType');
        }
        });
	
});

	function testFunc() {
		var url = "/logistics/returnusedparts/ReturnUsedPartsTest.do";
		var param = "param=BS8362806";

		Common.ajax("GET", url, param, function(data) {
			//AUIGrid.setGridData(listGrid, data.data);
			alert(data);
			$("#search").click();
		});
	}
	
	
	function deltestFunc() {
        var url = "/logistics/returnusedparts/ReturnUsedPartsDelTest.do";
        var param = "param=BS8362776";

        Common.ajax("GET", url, param, function(data) {
            //AUIGrid.setGridData(listGrid, data.data);
            alert(data);
            $("#search").click();
        });
    }

	function SearchListAjax() {
		var url = "/logistics/returnusedparts/returnPartsSearchList.do";
		var param = $('#searchForm').serialize();

		Common.ajax("GET", url, param, function(data) {
			AUIGrid.setGridData(listGrid, data.data);
		    
		});
	}

	function f_getTtype(g, v) {
		var rData = new Array();
		$.ajax({
			type : "GET",
			url : "/common/selectCodeList.do",
			data : {
				groupCode : g,
				orderValue : 'CRT_DT',
				likeValue : v
			},
			dataType : "json",
			contentType : "application/json;charset=UTF-8",
			async : false,
			success : function(data) {
				$.each(data, function(index, value) {
					var list = new Object();
					list.code = data[index].code;
					list.codeId = data[index].codeId;
					list.codeName = data[index].codeName;
					rData.push(list);
				});
			},
			error : function(jqXHR, textStatus, errorThrown) {
				Common.alert("Draw ComboBox['" + obj
						+ "'] is failed. \n\n Please try again.");
			},
			complete : function() {
			}
		});

		return rData;
	}

	function upReturnParts() {

		var data = {};
		var checkdata = AUIGrid.getCheckedRowItemsAll(listGrid);
		data.checked = checkdata;

		Common.ajax("POST","/logistics/returnusedparts/returnPartsUpdate.do", data, function(result) {
			if(result.data==0 ){
				Common.alert(result.message);
			   $("#search").click();
			}else{
				Common.alert('Already processed.');
			}

		})
	 }		
	function cancleReturnParts() {

       var data = {};
       var checkdata = AUIGrid.getCheckedRowItemsAll(listGrid);
       data.checked = checkdata;

       Common.ajax("POST","/logistics/returnusedparts/returnPartsCanCle.do", data, function(result) {
           
                   Common.alert(result.message);

       })			
	}
	
	function f_validatation(v) {

		if (v == 'save') {
			var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
			for (var i = 0; i < checkedItems.length; i++) {
				if (checkedItems[i].qty == 0 || checkedItems[i].qty == null || checkedItems[i].qty == "" || undefined) {
					Common.alert("Please enter Request Qty");
					return false;
				}
			}
			return true;
		}
	}
	
	   function validMatCodeAjax(matcode,indexnum) {
	        var url = "/logistics/returnusedparts/validMatCodeSearch.do";
	        var param = {"matcode":matcode};
	     
	        Common.ajax("GET", url, param, function(data) {
	     
	        	if(data.data == 0){
	        		Common.alert("The product code is incorrect.");
	        		AUIGrid.setCellValue(listGrid , indexnum , "materialCode" , "" );	        		
	        	}
	        	//$("#search").click();
	        });
	    }
	   
	   function f_multiComboType() {
		    $(function() {
		        $('#searchLoc').change(function() {
		        }).multipleSelect({
		            selectAll : true
		        });
		    });
		}
	
</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>logistics</li>
    <li>return Used Parts List</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Return Used Parts List</h2>
</aside><!-- title_line end -->



<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
    <ul class="right_btns">
<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
      <li><p class="btn_blue"><a id="delete"><span class="delete"></span>Delete</a></p></li>
</c:if>
      <!-- <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li> -->
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
      <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
</c:if>
<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
      <li><p class="btn_blue"><a id="complete"><span class="complete"></span>Complete</a></p></li>
</c:if>
      <!-- <li><p class="btn_gray"><a id="cancle"><span class="cancle"></span>Cancle</a></p></li> -->
    </ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
    <form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
        <table class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:140px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
                 <tr>
                   <th scope="row">Location Type</th>
                   <td>
                        <select class="w100p" id="searchlocgb" name="searchlocgb"></select>
                   </td>
                    <th scope="row">Location Grade</th>
                   <td>
                        <select class="w100p" id="searchlocgrade" name="searchlocgrade"></select>
                   </td>
                   <th scope="row">Location</th>
                   <td>
<!--                        <select class="w100p" id="searchLoc" name="searchLoc"><option value="">Choose One</option></select> -->
                       <select class="w100p" id="searchLoc" name="searchLoc"></select>
                   </td>              
                </tr>
                <tr>
                    <th scope="row">Branch</th>
                   <td>
                        <select class="w100p" id="searchBranch"  name="searchBranch"></select>
                   </td> 
                   <th scope="row">Oder</th>
                   <td>
                        <INPUT type="text"   class="w100p" id="searchOder" name="searchOder">
                   </td> 
                   <th scope="row">Customer</th>
                   <td>
                        <INPUT type="text"   class="w100p" id="searchCustomer" name="searchCustomer">
                   </td>         
                </tr>
                <tr>
                    <th scope="row">Service date</th>
                    <td>
                        <div class="date_set w100p"><!-- date_set start -->
                        <p><input id="servicesdt" name="servicesdt" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"></p>   
                        <span> To </span>
                        <p><input id="serviceedt" name="serviceedt" type="text" title="Create End Date" placeholder="DD/MM/YYYY" class="j_date "></p>
                        </div><!-- date_set end -->                        
                    </td>
                    <th scope="row">Return Date</th>
                    <td >
                        <div class="date_set w100p"><!-- date_set start -->
                        <p><input id="returnsdt" name="returnsdt" type="text" title="Create start Date"  placeholder="DD/MM/YYYY" class="j_date"></p>   
                        <span> To </span>
                        <p><input id="returnedt" name="returnedt" type="text" title="Create End Date"  placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    </td>     
                    <th scope="row"></th>
                    <td>
                    </td>         
                </tr>
                <tr>
                    <th scope="row">Material Code</th>
                   <td>
                       <INPUT type="text"   class="w100p" id="searchMaterialCode" name="searchMaterialCode">
                   </td>  
                   <th scope="row">Material Type</th>
                   <td >
                      <select class="w100p" id="searchMaterialType" name="searchMaterialType"></select>
                   </td> 
                   <th scope="row">Complete</th>
                   <td>
                       <select class="w100p" id="searchComplete" name="searchComplete"></select>
                   </td>
                </tr>
                             
            </tbody>
        </table><!-- table end -->
    </form>

    </section><!-- search_table end -->

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->
    
        <ul class="right_btns">
<c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
         <li><p class="btn_grid"><a id="download"><spring:message code='sys.btn.excel.dw' /></a></p></li>
</c:if>        
<!--          <li><p class="btn_grid"><a id="insert">INS</a></p></li>             -->
        </ul>

        <div id="main_grid_wrap" class="mt10" style="height:450px"></div>
        

    </section><!-- search_result end -->

</section>

