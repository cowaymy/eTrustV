<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
var gridID;
var gridID1;
var type1;
var holidayDesc1;
var holiday1;
var state1;
var holidaySeq1;
var grpOrgList= new Array();
var rData = new Array();
function holidayCTassignGrid() {
    
    var columnLayout = [
                          { dataField : "holidayType", headerText  : "Holiday Type",    width : 100 },
                          { dataField : "state", headerText  : "State",width : 100 },
                          { dataField : "holiday", headerText  : "Date",  width  : 100, dataType : "date"},
                          { dataField : "holidayDesc",       headerText  : "Description",  width  : 200},
                          { dataField : "holidaySeq",       headerText  : "",  width  : 0},
                          { dataField : "ctBrnchCode",       headerText  : "Branch",  width  : 100},
                          { dataField : "replacementCtPax",       headerText  : "Replacement CT Pax",  width  : 100},
                          { dataField : "assignStatus",       headerText  : "Assign Status",  width  : 100},
                          { dataField : "applCode",       headerText  : "Working Status",  width  : 150, editRenderer : {
                              type : "ComboBoxRenderer",
                              showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                              listFunction : function(rowIndex, columnIndex, item, dataField) {
                                  var list = getTypeWorkList();
                                  return list;
                              },
                              keyField : "id1"
                          }
                        	  },
                          { dataField : "brnchId",       headerText  : "",  width  : 0}
                          
                           
       ];

        var gridPros = { usePaging : true,  pageRowCount: 20, editable: true, selectionMode : "singleRow",  showRowNumColumn : true, showStateColumn : false};  
        
        gridID1 = GridCommon.createAUIGrid("holiday_CTassign_grid_wap", columnLayout  ,"" ,gridPros);
    }
    
function holidayGrid() {
	   
    var columnLayout = [
                          { dataField : "holidayType", headerText  : "Holiday Type",    width : 100 ,
                        	  editRenderer : {
                                  type : "ComboBoxRenderer",
                                  showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                  listFunction : function(rowIndex, columnIndex, item, dataField) {
                                      var list = getTypeComboList();
                                      return list;
                                  },
                                  keyField : "id1"
                              }
                          },
                          { dataField : "state", headerText  : "State",     width : 200 ,
                        	  editRenderer : {
                        		  type : "ComboBoxRenderer",
                                  showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                  listFunction : function(rowIndex, columnIndex, item, dataField) {
                                      var list = rData;
                                      return list;
                                  },
                                  keyField : "state",
                                  valueField : "codeName"
                        	  }
                          },
                          { dataField : "holiday", headerText  : "Date",  width  : 100, dataType : "date" ,
                        	  editRenderer : {
                                  type : "CalendarRenderer",
                                  showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 출력 여부
                                  showExtraDays : true // 지난 달, 다음 달 여분의 날짜(days) 출력
                                },
                                onlyCalendar : false // 사용자 입력 불가, 즉 달력으로만 날짜입력 (기본값 : true)
                          },
                          { dataField : "holidayDesc",       headerText  : "Description",  width  : 200},
                          { dataField : "holidaySeq",       headerText  : "",  width  : 0}
                          
                           
       ];
	    
        var gridPros = { usePaging : true,  pageRowCount: 20, editable: true, selectionMode : "singleRow",  showRowNumColumn : true, showStateColumn : false};  
        
        gridID = GridCommon.createAUIGrid("holiday_grid_wap", columnLayout  ,"" ,gridPros);
        
        // 에디팅 정상 종료 이벤트 바인딩
        AUIGrid.bind(gridID, "cellEditEnd", auiCellEditingHandler);

    }
function getStateComboList() {
    var list = [ "Johor", "Perlis", "Pahang" ];
    return list;
}



function getTypeComboList() {
    //var list = [ {"codeId": "P","codeName": "PUBLIC"}, {"codeId": "S","codeName": "STATE"}];
   var list = [ "Public Holiday","State Holiday"];
    return list;
}

function getTypeWorkList() {
   var list = [ "Working","Holiday"];
    return list;
}

function fn_selectState(){
	 Common.ajax("GET", "/services/holiday/selectState.do",$("#holidayForm").serialize(), function(result) {
         console.log("성공.");
         console.log("data : " + result);
         
         for (var i = 0; i < result.length; i++) {
             var list = new Object();
             list.codeId = result[i].codeId;
             list.state = result[i].codeId;
             list.codeName = result[i].codeName;
             rData.push(list);
              }
        });
	 return rData;
}

function addRow() {
    var item = new Object();
    item.holidayType = "";
    item.state = "";
    item.holiday = "";
    item.dscription = "";
    // parameter
    // item : 삽입하고자 하는 아이템 Object 또는 배열(배열인 경우 다수가 삽입됨)
    // rowPos : rowIndex 인 경우 해당 index 에 삽입, first : 최상단, last : 최하단, selectionUp : 선택된 곳 위, selectionDown : 선택된 곳 아래
    AUIGrid.addRow(gridID, item, "first");
}

// 편집 핸들러
function auiCellEditingHandler(event) {
	if(event.columnIndex == 0 && event.value == "Public Holiday"){
        AUIGrid.setCellValue(gridID, event.rowIndex,  1, "");
        AUIGrid.setColumnProp( gridID, 1, { editable : false } );
    } else if(event.columnIndex == 0 && event.value != "Public Holiday") {
    	AUIGrid.setColumnProp( gridID, 1, { editable : true } );
    }
};
	 
$(document).ready(function(){
	doGetCombo('/services/mileageCileage/selectBranch', 43, '','branchId', 'M' ,  'f_multiCombo');
	 holidayGrid();
	 holidayCTassignGrid();
	 fn_selectState();
	 $("#holiday_CTassign_grid_wap").hide();
	 $("#hiddenBtn").hide();
	 $("#hiddenBtn4").hide();
	 AUIGrid.bind(gridID, "addRow", auiAddRowHandler);
	 AUIGrid.bind(gridID, "removeRow", auiRemoveRowHandler);
	 
	 AUIGrid.bind(gridID, "cellClick", function(event) {
         console.log(event.rowIndex);
         type1= AUIGrid.getCellValue(gridID, event.rowIndex, "holidayType");
         holidayDesc1 = AUIGrid.getCellValue(gridID, event.rowIndex, "holidayDesc");
         holiday1 = AUIGrid.getCellValue(gridID, event.rowIndex, "holiday");
         state1 = AUIGrid.getCellValue(gridID, event.rowIndex, "state");
         holidaySeq1 = AUIGrid.getCellValue(gridID, event.rowIndex, "holidaySeq");
         
         console.log(type1 + "      " + holidayDesc1 + "    " + holiday1 + "   "  + holidaySeq1 + state1);
         
     });
	 
	 
	 AUIGrid.bind(gridID1, "cellClick", function(event) {
	        console.log(event.rowIndex);
	        type= AUIGrid.getCellValue(gridID1, event.rowIndex, "holidayType");
	        branchName = AUIGrid.getCellValue(gridID1, event.rowIndex, "ctBrnchCode");
	        holidayDesc = AUIGrid.getCellValue(gridID1, event.rowIndex, "holidayDesc");
	        holiday = AUIGrid.getCellValue(gridID1, event.rowIndex, "holiday");
	        branchId = AUIGrid.getCellValue(gridID1, event.rowIndex, "brnchId");
	        state = AUIGrid.getCellValue(gridID1, event.rowIndex, "state");
	        holidaySeq = AUIGrid.getCellValue(gridID1, event.rowIndex, "holidaySeq");
	        applCode = AUIGrid.getCellValue(gridID1, event.rowIndex, "applCode");
	        console.log(type + "      "+branchName + "     " + holidayDesc + "    " + holiday + "   " + branchId + "    " + holidaySeq + state);
	        
	    });
	 
	
	 doGetCombo('/services/holiday/selectState.do', '' , '', 'cmbState' , 'S', '');
});

    function fn_holidaySave(){
	    	if(fnValidationCheck()){
	    		Common.ajax("POST", "/services/holiday/saveHoliday.do", GridCommon.getEditData(gridID), function(result) {
	    			 var checkbeforeToday = {code: "00", message: "Already Gone"};
	    	         var checkExistHoliday={code: "00", message: "Already Exist"}   
	                console.log(result);
	    	         if(JSON.stringify(result) === JSON.stringify(checkbeforeToday) )  {
	                	 Common.alert("Already Gone");
	                 }
	    	         
	    	         if(JSON.stringify(result) === JSON.stringify(checkExistHoliday) )  {
                         Common.alert("The Holiday Exist Already");
                     }
	    			
	    			console.log("성공.");
	            console.log("data : " + result);
	        });
    	}
    }
    
    function f_multiCombo(){
    	 $(function() {
    	       
    	        $('#branchId').change(function() {
    	        }).multipleSelect({
    	            selectAll : true,
    	            width : '80%'
    	        });
    	    });
    }
    function fnValidationCheck() 
    {
    	 var result = true;
         var addList = AUIGrid.getAddedRowItems(gridID);
         var udtList = AUIGrid.getEditedRowItems(gridID);
         var delList = AUIGrid.getRemovedItems(gridID);
            
        if (addList.length == 0  && udtList.length == 0 && delList.length == 0) 
        {
          Common.alert("No Change");
          return false;
        }

        for (var i = 0; i < addList.length; i++) 
        {
        	var holidayType  = addList[i].holidayType;
            var holiday  = addList[i].holiday;
            var state = addList[i].state;
              if (holidayType == "" || holidayType.length == 0) 
              {
                result = false;
                // {0} is required.
                Common.alert("<spring:message code='sys.msg.necessary' arguments='Holiday Type' htmlEscape='false'/>");
                break;
              }
              
              if (holidayType == "Public Holiday") 
              {
            	  if (state.length > 0)
            	  {
            		result = false;
            	    Common.alert("<spring:message text='Not allowed to place a particular state for public holiday.' htmlEscape='false'/>");
            	    break;
            	  }
              } else {
            	  if (state == "" || state.length == 0) 
                  {
                    result = false;
                    // {0} is required.
                    Common.alert("<spring:message text='Required to place a state for the holiday type.' htmlEscape='false'/>");
                    break;
                  }
              }
              
              if (holiday == "" || holiday.length == 0) 
              {
                result = false;
                // {0} is required.
                Common.alert("<spring:message code='sys.msg.necessary' arguments='Holiday' htmlEscape='false'/>");
                break;
              }
              var today = new Date();
              
        }

        for (var i = 0; i < udtList.length; i++) 
        {
        	var holidayType  = udtList[i].holidayType;
            var holiday  = udtList[i].holiday; 
            var state = addList[i].state;
              if (holidayType == "" || holidayType.length == 0) 
              {
                result = false;
                // {0} is required.
                Common.alert("<spring:message code='sys.msg.necessary' arguments='Holiday Type' htmlEscape='false'/>");
                break;
              }
              
              if (holidayType == "Public Holiday") 
              {
                  if (state.length > 0)
                  {
                    result = false;
                    Common.alert("<spring:message text='Not allowed to place a particular state for public holiday.' htmlEscape='false'/>");
                    break;
                  }
              } else {
                  if (state == "" || state.length == 0) 
                  {
                    result = false;
                    // {0} is required.
                    Common.alert("<spring:message text='Required to place a state for the holiday type.' htmlEscape='false'/>");
                    break;
                  }
              }
              
              if (holiday == "" || holiday.length == 0) 
              {
                result = false;
                // {0} is required.
                Common.alert("<spring:message code='sys.msg.necessary' arguments='Holiday' htmlEscape='false'/>");
                break;
              }
        }

        for (var i = 0; i < delList.length; i++) 
        {
        	 var holidayType  = delList[i].holidayType;
             var holiday  = delList[i].holiday; 
               if (holidayType == "" || holidayType.length == 0) 
               {
                 result = false;
                 // {0} is required.
                 Common.alert("<spring:message code='sys.msg.necessary' arguments='Holiday Type' htmlEscape='false'/>");
                 break;
               }
               
               if (holiday == "" || holiday.length == 0) 
               {
                 result = false;
                 // {0} is required.
                 Common.alert("<spring:message code='sys.msg.necessary' arguments='Holiday' htmlEscape='false'/>");
                 break;
               }
        }

        return result;

    }
    
    function auiAddRowHandler(event) {
    }
    
    function fn_holidayListSearch(){
    	   Common.ajax("GET", "/services/holiday/searchHolidayList.do",$("#holidayForm").serialize(), function(result) {
            console.log("성공.");
            console.log("data : " + result);
            AUIGrid.setGridData(gridID, result);
    	   });
    	   
    	 
    	  
    	  $("#type1").val(type1.substr(0,1));
    	  $("#holidayDesc1").val(holidayDesc1);
    	  $("#holiday1").val( holiday1);
    	  $("#holidaySeq1").val(holidaySeq1);
    	  $("#state1").val(state1);
    	   console.log(type1 + "      " + holidayDesc1 + "    " + holiday1 + "   "  + holidaySeq1 + state1);
    	   Common.ajax("GET", "/services/holiday/searchCTAssignList.do", $("#holidayForm").serialize(), function(result) {
               console.log("성공.");
               console.log("data : " + result);
               AUIGrid.setGridData(gridID1, result);
              });
    	   
    	  
    	   type1 = "";
    	   holidayDesc1="";
    	   holiday1="";
    	   state1="";
    	   holidaySeq1="";
    	   console.log(type1 + "      " + holidayDesc1 + "    " + holiday1 + "   "  + holidaySeq1 + state1);
    }
    
    function fn_radioBtn(val){
    	if(val == 1){
            $("#holiday_grid_wap").show();
            $("#holiday_CTassign_grid_wap").hide();
            $("#hiddenBtn").hide();
            $("#hiddenBtn4").hide();
            $("#hiddenBtn1").show();
            $("#hiddenBtn2").show();
            $("#hiddenBtn3").show();
            AUIGrid.resize(holiday_grid_wap,1000,400);
        }else{
        	
        	   fn_holidayListSearch();  	
              $("#holiday_CTassign_grid_wap").show();
              $("#holiday_grid_wap").hide();
              $("#hiddenBtn").show();
              $("#hiddenBtn1").hide();
              $("#hiddenBtn2").hide();
              $("#hiddenBtn3").hide();
              $("#hiddenBtn4").show();
              AUIGrid.resize(holiday_CTassign_grid_wap,1000,400);
         }
   }
    function fn_CTEntry(){  
    	if(applCode == "Working"){
    		return;
    	}
    	 Common.popupDiv("/services/holiday/holidayReplacementCT.do?holidayType=" + type +"&branchName=" +  branchName +  "&holidayDesc=" + holidayDesc + "&holiday=" + holiday + "&branchId=" + branchId + "&state=" + state + "&holidaySeq=" + holidaySeq ,null, null , true , '_NewAddDiv1');
    }
    
    function fn_CTEntryEdit(){
    	Common.popupDiv("/services/holiday/updatHolidayReplacementCT.do?holidayType=" + type +"&branchName=" +  branchName +  "&holidayDesc=" + holidayDesc + "&holiday=" + holiday + "&branchId=" + branchId + "&state=" + state + "&holidaySeq=" + holidaySeq ,null, null , true , '_NewAddDiv1');
    } 
    
    function fn_ChangeApplType(){
    	
    
    	 Common.ajax("GET", "/services/holiday/changeApplType.do?holidayType=" + type +"&branchName=" +  branchName +  "&holidayDesc=" + holidayDesc + "&holiday=" + holiday + "&branchId=" + branchId + "&state=" + state + "&holidaySeq=" + holidaySeq+"&applCode=" + applCode,"",  function(result) {
    		 
    		 
    		 
    	 });
    	
    }
    function removeRow(){
    	AUIGrid.removeRow(gridID, "selectedIndex");
        AUIGrid.removeSoftRows(gridID);
    }
    
    
    


   
    function auiRemoveRowHandler(){}
</script>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>Holiday List Search</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Holiday List Search</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_holidayListSearch()"><span class="search"></span>Search</a></p></li>
<!--     <li><p class="btn_blue"><a href="#" onclick="javascript:fn_Clear()"><span class="clear"></span>Clear</a></p></li> -->
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="holidayForm">
<input type ="hidden" id="type1" name="type1">
<input type ="hidden" id="holidayDesc1" name="holidayDesc1">
<input type ="hidden" id="holiday1" name="holiday1">
<input type ="hidden" id="holidaySeq1" name="holidaySeq1">
<input type ="hidden" id="state1" name="state1">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Holiday Type</th>
    <td>
        <select class="w100p" id="type" name="type">
            <option value="">All</option>
            <option value="P">Public</option>
            <option value="S">State</option>
        </select>
    </td>
    <th scope="row">State</th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="cmbState" name="cmbState">
         <c:forEach var="list" items="${selectState}">
             <option value="${list.codeId}">${list.codeName}</option>
         </c:forEach>
        </select> 
    </td>
    <th scope="row">Holiday</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="holidayDt" name="holidayDt"/></td>
</tr>
<tr>
    <th scope="row">Assign Status</th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="assignState" name="assignState">
            <option value="Active">Active</option>
            <option value="Complete">Complete</option>
        </select>
    </td>
    <th scope="row" id="">Branch</th>
    <td>
        <div class="search_100p">
        <select class="multy_select w100p" multiple="multiple" id="branchId" name="branchId">
       <%--  <c:forEach var="list" items="${branchList}">
             <option value="${list.codeId}">${list.codeName}</option>
         </c:forEach> --%>
        </select>
        </div>
    </td>
    <th></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<%-- <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">Magic Address Download</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end --> --%>

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <td>
    <label><input type="radio" name="name" checked="checked" onclick="fn_radioBtn(1)"/><span>Holiday List Display</span></label>
    <label><input type="radio" name="name" onclick="fn_radioBtn(2)" /><span>Replacement CT Assign Status</span></label>
    </td>
</tr>
</tbody>
</table>

<ul class="right_btns">
    <li><p class="btn_grid" id="hiddenBtn1"><a href="#" onclick="javascript:addRow()">ADD</a></p></li>
    <li><p class="btn_grid" id="hiddenBtn2"><a href="#" onclick="javascript:removeRow()">DEL</a></p></li>
    <li><p class="btn_grid" id="hiddenBtn3"><a href="#" onclick="javascript:fn_holidaySave()">SAVE</a></p></li>
    <li><p class="btn_grid" id="hiddenBtn4"><a href="#" onclick="javascript:fn_ChangeApplType()">Change Work Status</a></p></li>
    <li><p class="btn_grid" id="hiddenBtn"><a href="#" onclick="javascript:fn_CTEntry()">Replacement CT Entry</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="holiday_grid_wap" style="width:100%; height:300px; margin:0 auto;"></div>
<div id="holiday_CTassign_grid_wap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
