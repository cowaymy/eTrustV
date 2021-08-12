<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

//Create And Return Grid ID
var agentGridID;
//Combo Option
var comboOption = { isShowChoose: false , type: "M"};
var comboStatusOption = { isShowChoose: false , type: "M", id: "stusCodeId", name: "codeName"};
//Grid Code Array
var typeArr;
var statusArr;


$(document).ready(function() {
    
	//get Code List 
    fn_getCodeList('329');
    fn_getCodeList('17');
	
	var typeParam = {codeMasterId : '329'};
	CommonCombo.make("_agentType", "/sales/rcms/selectAgentTypeList", typeParam, '',  comboOption);
	
	var statusParam = {selCategoryId : '17'};
	CommonCombo.make("_agentStatus", "/status/selectStatusCategoryCdList.do", statusParam, '',  comboStatusOption);
	
	//Create Grid
	createAgentGrid();
	
	//Save
	$("#_agentSave").click(function() {
		
		var isVal = true;
		
		//Validation 
		isVal = fn_chkAgentVal();
		
		//Save
		if(isVal == false){
			return;
		}else{
			
			//Save Start
			
		}
		
	});
	
	
	//Search
	$("#_agentSearch").click(function() {
		
		Common.ajax("GET", "/sales/rcms/selectAgentList", $("#_searchForm").serialize(), function(result){
			AUIGrid.setGridData(agentGridID, result);
		});
		
	});
	
//Grid Edit
AUIGrid.bind(agentGridID, "cellEditEndBefore", function( event ) {
	
	if(event.dataField == 'agentName'){
		if(event.value.length > 41){
			Common.alert('<spring:message code="sal.alert.msg.plzKeyinAgentNameUnder41Digit" />');
			
			if(event.oldValue == null || event.oldValue == ''){
				return '';
			}else{
				return event.oldValue;	
			}
		}else{
			return event.value;
		}
	}else{
		return event.value;
	}
});
	
});//Doc Ready Func End////////////////////

function fn_chkAgentVal(){
    
	//Add Objects
	var editArr = [];
	var isVal = true;
	var data = {};
	
	editArr = GridCommon.getEditData(agentGridID);
	
	//Valition 
	//1. NullCheck
	var agentSize = AUIGrid.getGridData(agentGridID);
    if(agentSize == null || agentSize.length <= 0){
        Common.alert('<spring:message code="sal.alert.msg.noChngData" />');
        return false;
    }
	
	if(editArr == null || editArr.size <= 0){
		Common.alert('<spring:message code="sal.alert.msg.noChngData" />');
		return false;
	}
	//1 - 1 . Add Row Check
	if(editArr.add != null || editArr.add.size > 0){
		$(editArr.add).each(function(idx, el) {
			//console.log("el["+idx+"] : " + el.agentName + " , " +  el.userId);
			if(el.agentName.trim() == ''){
				Common.alert('<spring:message code="sal.alert.msg.agentNameCannotBeEmpty" />');
				isVal = false;
				return false;
			}
			
			if(el.userId.trim() == ''  ){
				Common.alert('<spring:message code="sal.alert.msg.webIdCannotBeEmpty" />');
                isVal = false;
                return false;
			}
		});
		
		if(isVal == false){
			return;
		}
		
		data.add = editArr.add;
	}
	//1 - 2 . Update Row Check
	if(editArr.update != null || editArr.update.size > 0){
        $(editArr.update).each(function(idx, el) {
            //console.log("el["+idx+"] : " + el.agentName + " , " +  el.userId);
            if(el.agentName.trim() == ''){
                Common.alert('<spring:message code="sal.alert.msg.agentNameCannotBeEmpty" />');
                isVal = false;
                return false;
            }
            
            if(el.userId.trim() == ''  ){
                Common.alert('<spring:message code="sal.alert.msg.webIdCannotBeEmpty" />');
                isVal = false;
                return false;
            }
        });
        
        if(isVal == false){
            return;
        }
        
        data.upd = editArr.update;
    }
	//2. Web Id Check
	
	var rtnMsg = '';
	Common.ajax("POST", "/sales/rcms/checkWebId", data, function(result){
		
		if(result != null && result.length > 0){
			
			$(result).each(function(idx, el){
				if(idx == (result.length -1)){
					rtnMsg += el;	
				}else{
					rtnMsg += el+", ";	
				}
			});
		}
	}, null , {async : false});
	
	if(rtnMsg != ''){
		Common.alert('<spring:message code="sal.alert.msg.userWebIdNotValidbr" />' + rtnMsg);
		return;
	}
	
	//3. User Id Dup Check
	Common.ajax("POST", "/sales/rcms/chkDupWebId", data, function(result){
	    
		if(result != null && result.length > 0){
            
            $(result).each(function(idx, el){
                if(idx == (result.length -1)){
                    rtnMsg += el;   
                }else{
                    rtnMsg += el+", ";  
                }
            });
        }
	}, null , {async : false});
	
	if(rtnMsg != ''){
        Common.alert('<spring:message code="sal.alert.msg.dupUserWebId" />' + rtnMsg);
        return;
    }
	// ____________________Validation Success
	//Save
	Common.ajax("POST", "/sales/rcms/insUpdAgent.do", data, function(result){
		  Common.alert(result.message);
		  $("#_agentSearch").click(); //Reload...
	});
}

function fn_getCodeList(grpCode){
	//console.log("grpCode : " + grpCode);
	var url;
	
	if(grpCode == '329'){  //type Array
		url = '/sales/rcms/selectAgentTypeList';
	
		$.ajax({
	        type: 'get',
	        url : getContextPath() + url,
	        data : {codeMasterId : grpCode},
	        dataType : 'json',
	        async : false,
	        beforeSend: function (request) {
	             // loading start....
	             Common.showLoader();
	         },
	         complete: function (data) {
	             // loading end....
	             Common.removeLoader();
	         },
	         success: function(result) {
	             
	             var tempArr = new Array();
	             
	             for (var idx = 0; idx < result.length; idx++) {
	                 tempArr.push(result[idx]); 
	             }
	             typeArr = tempArr; 
	             
	             //console.log("typeArr : " + JSON.stringify(typeArr));
	             
	        },error: function () {
	            Common.alert("Fail to Get Code List....");
	        }
	        
	    });
	}
	if(grpCode == '17'){
		url = '/status/selectStatusCategoryCdList.do';
		
		$.ajax({
	        type: 'get',
	        url : getContextPath() + url,
	        data : {selCategoryId : grpCode},
	        dataType : 'json',
	        async : false,
	        beforeSend: function (request) {
	             // loading start....
	             Common.showLoader();
	         },
	         complete: function (data) {
	             // loading end....
	             Common.removeLoader();
	         },
	         success: function(result) {
	             
	             var tempArr = new Array();
	             
	             for (var idx = 0; idx < result.length; idx++) {
	                 tempArr.push(result[idx]); 
	             }
	             statusArr = tempArr; 
	             //console.log("statusArr : " + JSON.stringify(statusArr));
	        },error: function () {
	            Common.alert("Fail to Get Code List....");
	        }
	        
	    });
	}
	
}
//arrItmStusCode
function createAgentGrid(){
    
    
    var agentColumnLayout =  [ 
                            {dataField : "agentId", headerText : '<spring:message code="sal.title.text.agentId" />', width : '10%' , editable : false}, 
                            {dataField : "agentName", headerText : '<spring:message code="sal.title.text.agentName" />', width : '20%'},
                            { dataField : "agentType",  headerText : '<spring:message code="sal.title.text.agentType" />', width : '20%',
                                labelFunction : function( rowIndex, columnIndex, value, headerText, item) { 
                                     var retStr = "";
                                     for(var i=0,len=typeArr.length; i<len; i++) {
                                         if(typeArr[i]["codeId"] == value) {
                                             retStr = typeArr[i]["codeName"];
                                             break;
                                         }
                                     }
                                     return retStr == "" ? value : retStr;
                                 },
                                 editRenderer : { // 셀 자체에 드랍다운리스트 출력하고자 할 때
                                        type : "DropDownListRenderer",
                                        list : typeArr,
                                        keyField   : "codeId", // key 에 해당되는 필드명
                                        valueField : "codeName", // value 에 해당되는 필드명
                                        easyMode : false
                                  }
                            },
                            {dataField : "userId", headerText : '<spring:message code="sal.title.text.webId" />', width : '20%'},
                            {dataField : "crtDt", headerText : '<spring:message code="sal.title.text.registrationDate" />', width : '10%' , editable : false}, 
                            { dataField : "stusId",  headerText : '<spring:message code="sal.title.status" />', width : '20%',
                                labelFunction : function( rowIndex, columnIndex, value, headerText, item) { 
                                     var retStr = "";
                                     for(var i=0,len=statusArr.length; i<len; i++) {
                                         if(statusArr[i]["stusCodeId"] == value) {
                                             retStr = statusArr[i]["codeName"];
                                             break;
                                         }
                                     }
                                     return retStr == "" ? value : retStr;
                                 },
                                 editRenderer : { // 셀 자체에 드랍다운리스트 출력하고자 할 때
                                        type : "DropDownListRenderer",
                                        list : statusArr,
                                        keyField   : "stusCodeId", // key 에 해당되는 필드명
                                        valueField : "codeName", // value 에 해당되는 필드명
                                        easyMode : false
                                  }
                            }
                           ];
    
    //그리드 속성 설정
    var gridPros = {
            
            usePaging           : true,         //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            fixedColumnCount    : 1,            
            showStateColumn     : true,             
            displayTreeOpen     : false,            
     //       selectionMode       : "singleRow",  //"multipleCells",  
            softRemovePolicy : "exceptNew", //사용자추가한 행은 바로 삭제
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true
    };
    
    agentGridID = GridCommon.createAUIGrid("#agent_grid_wrap", agentColumnLayout,'', gridPros);  // address list
}


//Grid Add Row
function addRowToGrid(){
	    var item = new Object();
	   
	    item.agentId = "";
	    item.agentName = "";
	    item.agentType = "2327";
	    item.userId = "";  
	    item.crtDt = "";
	    item.stusId = "1";
	    
	    AUIGrid.addRow(agentGridID, item, "first");
}
</script>

<section id="content"><!-- content start -->

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="sal.title.text.agentMgnt" /></h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue"><a id="_agentSave"><span></span><spring:message code="sal.btn.save" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a id="_agentSearch"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    </c:if>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form  id="_searchForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.title.text.agentType" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="_agentType" name="agentType"></select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.agentName" /></th>
    <td>
    <input type="text" title="Agent Name" placeholder="Agent Name" class="w100p" name="agentName" />
    </td>
    <th scope="row"><spring:message code="sal.title.status" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="_agentStatus" name="agentStatus"></select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_grid"><a onclick="javascript : addRowToGrid()"><spring:message code="sal.btn.addBtn" /></a></p></li>
    </c:if>
</ul>

<aside class="title_line"><!-- title_line start -->
<h3><spring:message code="sal.title.text.agentResult" /></h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="agent_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->