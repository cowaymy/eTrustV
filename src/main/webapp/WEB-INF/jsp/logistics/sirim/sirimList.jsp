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


    // AUIGrid 생성 후 반환 ID
    var myGridID;
        

    // AUIGrid 칼럼 설정                                                                            visible : false
var columnLayout = [{dataField: "sirimNo",headerText :"<spring:message code='log.head.sirimno'/>"              ,width:  "30%"     ,height:30 , visible:true},               
{dataField: "sirimTypeName",headerText :"<spring:message code='log.head.type'/>"               ,width:  "30%"    ,height:30 , visible:true},                
{dataField: "sirimLoc",headerText :"<spring:message code='log.head.location'/>"     ,width: "40%"    ,height:30 , visible:true}
                       ];
    
 /* 그리드 속성 설정
  usePaging : true, pageRowCount : 30,  fixedColumnCount : 1,// 페이지 설정
  editable : false,// 편집 가능 여부 (기본값 : false) 
  enterKeyColumnBase : true,// 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
  selectionMode : "multipleCells",// 셀 선택모드 (기본값: singleCell)                
  useContextMenu : true,// 컨텍스트 메뉴 사용 여부 (기본값 : false)                
  enableFilter : true,// 필터 사용 여부 (기본값 : false)            
  useGroupingPanel : true,// 그룹핑 패널 사용
  showStateColumn : true,// 상태 칼럼 사용
  displayTreeOpen : true,// 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
  noDataMessage : "출력할 데이터가 없습니다.",
  groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
  rowIdField : "stkid",
  enableSorting : true,
  showRowCheckColumn : true,
  */
    var gridoptions = {showStateColumn : false , editable : false, pageRowCount : 30, usePaging : true, useGroupingPanel : false };
    
    var subgridpros = {
            // 페이지 설정
            usePaging : true,                
            pageRowCount : 10,                
            editable : true,                
            noDataMessage : "출력할 데이터가 없습니다.",
            enableSorting : true,
            softRemoveRowMode:false
            };
    

    $(document).ready(function(){
        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);
               
        doGetCombo('/common/selectCodeList.do', '11', '','searchCategory', 'S' , ''); //Type 리스트 조회
        doGetCombos('/logistics/sirim/selectWarehouseList.do', '', '','searchWarehouse', 'S' , ''); //Warehouse 리스트 조회
        
        AUIGrid.bind(myGridID, "cellClick", function( event )  
        {
            
            
        });
        
        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
        {
            
        });
       
        /* 팝업 드래그 start */
        $("#popup_wrap, .popup_wrap").draggable({handle: '.pop_header'});
        /* 팝업 드래그 end */
        });
    
    
    $(function(){
   	    $("#search").click(function(){
            getSirimListAjax();   
         });   
   	    
        $("#clear").click(function(){
        	$("#searchSirimNo").val('');
            doGetCombo('/common/selectCodeList.do', '11', '','searchCategory', 'S' , ''); //Type 리스트 조회
            doGetCombos('/logistics/sirim/selectWarehouseList.do', '', '','searchWarehouse', 'S' , ''); //Warehouse 리스트 조회
        });
    	    
   	    $("#insert").click(function(){
   	       $("#newSirimWindow").show();
   	       doGetCombos('/logistics/sirim/selectWarehouseList.do', '', '','addWarehouse', 'S' , ''); //Warehouse 리스트 조회      
   	       doGetCombo('/common/selectCodeList.do', '11', '','addTypeSirim', 'S' , ''); //Type 리스트 조회
   	       }); 
   	    
   	    $("#btnGenerate_Add").click(function(){
   	    	var lNo ="";
 	        var SirimNoFirst = $("#addSirimNoFirst").val();
 	        var quantity = $("#addQuantity").val();
 	         quantity=parseInt(quantity);
 	       
 	        if ($("#addQuantity").val() == "") {
 	            Common.alert("* Please key in quantity.");
 	            $("#addQuantity").focus();
 	            return ;
 	        }else{
 	        	 lNo= getLastNo(SirimNoFirst,quantity);
 	            
 	             $("#addSirimNoLast").val(lNo); 
 	             
 	              if (lNo.length > SirimNoFirst.length){
 	                 alert("* Invalid first number. Ending number exceed length.");
 	             }else{
 	                 $("#addSirimNoLast").val(lNo); 
 	             }      
 	        }
 	           	        
     }); 
   	    
   	 $("#btnRekey_Add_Click").click(function(){
   		$("#addSirimNoFirst").val(""); 
   		$("#addSirimNoLast").val("");       
   	  });   
	  
    	  
    });
    
    
    function getSirimListAjax() {  
        Common.ajax("POST", "/logistics/sirim/selectSirimList.do",  $('#SearchForm').serializeJSON(), function(result) {
      	  var gridData = result;             
                      
          AUIGrid.setGridData(myGridID, gridData.data);	
        // 공통 메세지 영역에 메세지 표시.
        Common.setMsg("<spring:message code='sys.msg.success'/>");
        //searchList();
        }, function(jqXHR, textStatus, errorThrown) {
            Common.alert("실패하였습니다.");
        });
}    
    
    function newSirimAjax() {  
        Common.ajax("POST", "/logistics/sirim/insertSirimList.do",  $('#AddSirimForm').serializeJSON(), function(result) {
          var gridData = result;
          cancelAddSirim()
                      
        // 공통 메세지 영역에 메세지 표시.
        Common.setMsg("<spring:message code='sys.msg.success'/>");
        }, function(jqXHR, textStatus, errorThrown) {
            Common.alert("실패하였습니다.");
        });
}    
    
    function SirimNocheckAjax() {
    
    	var prefix = $("#addPrefixNo").val();
    	var first = $("#addSirimNoFirst").val();
    	var iCnt = $("#addQuantity").val();
    	
     	var param = "";
    	var chekFlag ="";

    	param = { 
    			"prefix" : prefix,
    			"first" :  first,
    			"iCnt" :  iCnt
               };
	        Common.ajaxSync("post", "/logistics/sirim/selectSirimNo.do", param, function(result) {
	//           var gridData = result;    
	        chekFlag=result.data;
	         return chekFlag;
	    
	        // 공통 메세지 영역에 메세지 표시.
	        //Common.setMsg("<spring:message code='sys.msg.success'/>");
	        }, function(jqXHR, textStatus, errorThrown) {
	            Common.alert("실패하였습니다.");
	        });
	        return chekFlag;
}       
    
    function addSirim(){
  
    	if(valiedcheck()){
    		$("#addWarehouse").attr("disabled",false); 
    		$("#addSirimNoLast").attr("disabled",false); 
    		newSirimAjax();
    	}
    	
    	
    } 
    
    
    function cancelAddSirim(){
    	$('#AddSirimForm')[0].reset();
    	$("#newSirimWindow").hide();
    } 
   
    
    
    
    
    function getLastNo(SirimNoFirst,quantity){
     
    	var retLastNo ="";
    	var firstNoInt = 0;
    	var lastNoInt = 0;
    	  	
     	firstNoInt = parseInt(SirimNoFirst);
     	lastNoInt = firstNoInt + (quantity - 1);
     
    	retLastNo = lastNoInt.toString();
    	
      	  if (SirimNoFirst.length  > retLastNo.length ){
             var lengthToRun = (SirimNoFirst.length - retLastNo.length); 
             for (var int = 1; int <= lengthToRun; int++) {
                retLastNo = "0" + retLastNo;	
			}   
            
     	} 
     	 return retLastNo;
    } 
    
    
    function valiedcheck() {
    	var StartSirimNo = $("#addPrefixNo").val() + $("#addSirimNoFirst").val();
    	//var EndSirimNo =  $("#addPrefixNo").val() + $("#addSirimNoLast").val();
    	
    	
        if ($("#addTypeSirim").val() == "") {
            Common.alert("* Please select the type of Sirim.");
            $("#addTypeSirim").focus();
            return false;
        }
        if ($("#addPrefixNo").val() == "") {
            Common.alert("* Please key in the prefix number.");
            $("#addPrefixNo").focus();
            return false;
        }
        if ($("#addQuantity").val() == "") {
            Common.alert("* Please key in quantity.");
            $("#addQuantity").focus();
            return false;
        }
        if ($("#addSirimNoFirst").val() == "") {
            Common.alert("* Please key in first Sirim number.");
            $("#addSirimNoFirst").focus();
            return false;
        }
        
        if ($("#addSirimNoLast").val() == "") {
            Common.alert("* Generate Last Number Summary.");
            $("#addSirimNoLast").focus();
            return false;
        }      
        
        if (StartSirimNo.length >10) {
            Common.alert("* Generate SirimNo no lenth.");
            $("#addSirimNoFirst").focus();
            return false;
        }  
        
          if(SirimNocheckAjax() == "N"){
        	alert("* This sirim number is existing or it might be used.");
        	return false;
        }  
       
        return true;
    }
     
    
//Warehouse 셀렉트박스 CODE+CODENAME    
    function doGetCombos(url, groupCd , selCode, obj , type, callbackFn){
        
        $.ajax({
            type : "GET",
            url : getContextPath() + url,
            data : { groupCode : groupCd},
            dataType : "json",
            contentType : "application/json;charset=UTF-8",
            success : function(data) {
               var rData = data;
               doDefCombos(rData, selCode, obj , type,  callbackFn);
            },
            error: function(jqXHR, textStatus, errorThrown){
                alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
            },
            complete: function(){
            }
        }); 
    } ;    
    
    
    function doDefCombos(data, selCode, obj , type, callbackFn){
        var targetObj = document.getElementById(obj);
        var custom = "";
        
        for(var i=targetObj.length-1; i>=0; i--) {
            targetObj.remove( i );
        }
        obj= '#'+obj;
        if (type&&type!="M") {
            custom = (type == "S") ? eTrusttext.option.choose : ((type == "A") ? eTrusttext.option.all : "");               
            $("<option />", {value: "", text: custom}).appendTo(obj);
        }else{
            $(obj).attr("multiple","multiple");
        }
        
        $.each(data, function(index,value) {
            //CODEID , CODE , CODENAME ,,description
                if(selCode==data[index].codeId){
                    $('<option />', {value : data[index].code, text:data[index].code+"-"+data[index].codeName}).appendTo(obj).attr("selected", "true");
                }else{
                    $('<option />', {value : data[index].code, text:data[index].code+"-"+data[index].codeName}).appendTo(obj);
                }
            });    
                        
        
        if(callbackFn){
            var strCallback = callbackFn+"()";
            eval(strCallback);
        }
    };
    
    
//     function f_WarehouseCombo() {
//         $(function() {
//               $("#addWarehouse").val("CDB-HQ").prop("selected", true);
              
   
//           });       
//     }
    

</script>
</head>
<body>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sirim</li>
    <li>Sirim list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Sirim Management </h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="SearchForm" name="SearchForm"   method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Sirim No</th>
    <td>
    <input type="text" id="searchSirimNo" name="searchSirimNo" title="" placeholder="Sirim No" class="w100p" />
    </td>
    <th scope="row">Category</th>
    <td>
    <select id="searchCategory" name="searchCategory" class="w100p" >
    </select>
    </td>
    <th scope="row">Warehouse</th>
    <td>
    <select id="searchWarehouse" name="searchWarehouse" class="w100p">
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->


</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
<!--     <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li> -->
<!--     <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li> -->
<!--     <li><p class="btn_grid"><a href="#">DEL</a></p></li> -->
    <li><p class="btn_grid"><a id="insert"><spring:message code='sys.btn.ins' /></a></p></li>
    <!-- <li><p class="btn_grid"><a href="#">ADD</a></p></li> -->
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap"></div>

</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<div id="newSirimWindow" style="display:none" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Add New Sirim</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<form id="AddSirimForm" name="AddSirimForm" method="POST">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Warehouse<span class="must">*</span></th>
    <td>
     <select id="addWarehouse" name="addWarehouse" onchange=""  placeholder=""  class="w100p"></select> 
    </td>
    <th scope="row">Type of Sirim<span class="must">*</span></th>
    <td>
    <select id="addTypeSirim" name="addTypeSirim" onchange=""  placeholder=""  class="w100p"></select> 
    </td>
</tr>
<tr>
    <th scope="row">Prefix No<span class="must">*</span></th>
    <td>
    <input type="text" id="addPrefixNo" name="addPrefixNo" title="" placeholder="" class="w100p" />
    </td>
    <th scope="row">Quantity<span class="must">*</span></th>
    <td>
    <input type="text" id="addQuantity" name="addQuantity" title="" placeholder="" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Sirim No (First)<span class="must">*</span></th>
    <td>
    <input type="text" id="addSirimNoFirst" name="addSirimNoFirst" title="" placeholder="" class="" style="width:200px;" /><p class="btn_sky"><a id="btnGenerate_Add">Generate</a></p>
    </td>
    <th scope="row">Sirim No (Last)<span class="must">*</span></th>
    <td>
    <input type="text" id="addSirimNoLast" name="addSirimNoLast" title="" placeholder="" class="" style="width:200px;" disabled=true  /><p class="btn_sky"><a id="btnRekey_Add_Click">Re-Key</a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
      <li><p class="btn_blue2 big"><a onclick="javascript:addSirim();">SAVE</a></p></li> 
      <li><p class="btn_blue2 big"><a onclick="javascript:cancelAddSirim();">CANCEL</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->







</section><!-- content end -->

