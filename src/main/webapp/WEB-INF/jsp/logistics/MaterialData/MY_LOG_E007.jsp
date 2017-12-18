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


#editWindow {
    font-size:13px;
}
#editWindow label, input { display:block; }
#editWindow input.text { margin-bottom:10px; width:95%; padding: 0.1em;  }
#editWindow fieldset { padding:0; border:0; margin-top:10px; }
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">

    // AUIGrid 생성 후 반환 ID
    var myGridID;
    var detailGrid;

    // 등록창
    var insdialog;
    
    // 수정창
    var dialog;
    
    var itemdata;
    
    var comboData = [{"codeId": "1","codeName": "Y"},{"codeId": "8","codeName": "N"}];
    var stockgradecomboData = [{"codeId": "A","codeName": "A"},{"codeId": "B","codeName": "B"}];
    
    // AUIGrid 칼럼 설정             // formatString : "mm/dd/yyyy",    dataType:"numeric", formatString : "#,##0"
var columnLayout = [{dataField: "itmCode",headerText :"<spring:message code='log.head.materialcode'/>"     ,width:120    ,height:30 , visible:true},                        
							{dataField: "itmName",headerText :"<spring:message code='log.head.materialname'/>"     ,width:250    ,height:30 , visible:true},                        
							{dataField: "itmDesc",headerText :"<spring:message code='log.head.materialdetaildesc'/>"     ,width:350    ,height:30 , visible:true},                          
							{dataField: "itmId",headerText :"<spring:message code='log.head.itmid'/>"             ,width:140    ,height:30 , visible:false},                        
							{dataField: "codeName",headerText :"<spring:message code='log.head.keyprodgroup'/>"   ,width:   "12%"     ,height:30 , visible:true},               
							{dataField: "attachImgLoc",headerText :"<spring:message code='log.head.attachimgloc'/>"   ,width:120    ,height:30 , visible:false},                        
							{dataField: "ctgryId",headerText :"<spring:message code='log.head.ctgryid'/>"           ,width:120    ,height:30 , visible:true},                       
							{dataField: "isAttachImg",headerText :"<spring:message code='log.head.isattachimg'/>"       ,width:120    ,height:30 , visible:false},                          
							{dataField: "isHotItm",headerText :"<spring:message code='log.head.hotitm'/>"            ,width:90     ,height:30 , visible:false},                         
							{dataField: "isNwItm",headerText :"<spring:message code='log.head.newitm'/>"             ,width:90     ,height:30 , visible:false},                         
							{dataField: "isPromoItm",headerText :"<spring:message code='log.head.promoitm'/>"          ,width:120    ,height:30 , visible:false},                       
							{dataField: "itemType",headerText :"<spring:message code='log.head.itemtype'/>"        ,width:100    ,height:30 , visible:false},                       
							{dataField: "uom",headerText :"<spring:message code='log.head.unitofmeasure'/>"  ,width:100    ,height:30 , visible:false},                         
							{dataField: "uomname",headerText :"<spring:message code='log.head.unitofmeasure'/>"  ,width:100    ,height:30 , visible:true},                          
							{dataField: "currency",headerText :"<spring:message code='log.head.currency'/>"         ,width:100    ,height:30 , visible:false},                          
							{dataField: "currencynm",headerText :"<spring:message code='log.head.currency'/>"           ,width:100    ,height:30 , visible:true},                       
							{dataField: "prc",headerText :"<spring:message code='log.head.prc'/>"                ,width:100    ,height:30 , visible:true , dataType:"numeric", formatString : "#.00"    },          
							{dataField: "prcRem",headerText :"<spring:message code='log.head.prcrem'/>"           ,width:100    ,height:30 , visible:false},                        
							{dataField: "promoNormalPrc",headerText :"<spring:message code='log.head.promonormalprc'/>"   ,width:100    ,height:30 , visible:false},                        
							{dataField: "seq",headerText :"<spring:message code='log.head.seq'/>"                ,width:100    ,height:30 , visible:false},                         
							{dataField: "stusCodeId",headerText :"<spring:message code='log.head.stuscodeid'/>"       ,width:100    ,height:30 , visible:false},                        
							{dataField: "crtDt",headerText :"<spring:message code='log.head.crtdt'/>"              ,width:100    ,height:30 , visible:false , formatString : "mm/dd/yyyy"   },                  
							{dataField: "crtUserId",headerText :"<spring:message code='log.head.crtuserid'/>"          ,width:100    ,height:30 , visible:false},                       
							{dataField: "updDt",headerText :"<spring:message code='log.head.upddt'/>"              ,width:100    ,height:30 , visible:false},                       
							{dataField: "updUserId",headerText :"<spring:message code='log.head.upduserid'/>"          ,width:100    ,height:30 , visible:false},                       
							{dataField: "codeId",headerText :"<spring:message code='log.head.codeid'/>"           ,width:   "8%"       ,height:30 , visible:false},                 
							{dataField: "codeName",headerText :"<spring:message code='log.head.codename'/>"        ,width:  "8%"       ,height:30 , visible:true},                  
							{dataField: "oldStkId",headerText :"<spring:message code='log.head.codeid'/>"             ,width:   "8%"       ,height:30 , visible:false},                 
							{dataField: "PRD",headerText :"<spring:message code='log.head.productdisplaydummyset'/>"       ,width:  "8%"       ,height:30 , visible:true
                        	, renderer : 
                            {
                                type : "CheckBoxEditRenderer",
                                showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
                                editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
                                checkValue : "1426", // true, false 인 경우가 기본
                                unCheckValue : ""
                            }
                        },
                        	{dataField:    "CDTL",headerText :"<spring:message code='log.head.codytools'/>"                   ,width:  "8%"       ,height:30 , visible:true                
                        	, renderer : 
	                        {
	                            type : "CheckBoxEditRenderer",
	                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
	                            checkValue : "1362", // true, false 인 경우가 기본
	                            unCheckValue : ""
	                            
	                        }     
                        },
                        	{dataField: "HRI",headerText :"<spring:message code='log.head.hritem'/>"                      ,width:   "8%"       ,height:30 , visible:true                
                        	, renderer : 
	                        {
	                            type : "CheckBoxEditRenderer",
	                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
	                            checkValue : "1350", // true, false 인 경우가 기본
	                            unCheckValue : false
	                            
	                           
	                        }
	                                  
	                    },
                        	{dataField: "FINI",headerText :"<spring:message code='log.head.financeitem'/>"               ,width:    "8%"       ,height:30 , visible:true                
	                    	, renderer : 
	                        {
	                            type : "CheckBoxEditRenderer",
	                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
	                            checkValue : "1349", // true, false 인 경우가 기본
	                            unCheckValue : ""
	                            
	                           
	                        }
                                  
	                    },
                        	{dataField: "MISC",headerText :"<spring:message code='log.head.miscitem'/>"                 ,width: "8%"       ,height:30 , visible:true                
	                    	, renderer : 
	                        {
	                            type : "CheckBoxEditRenderer",
	                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
	                            checkValue : "1348", // true, false 인 경우가 기본
	                            unCheckValue : ""
	                            
	                           
	                        }
	                                  
	                    },
                        	{dataField: "UNM",headerText :"<spring:message code='log.head.uniform'/>"                    ,width:    "8%"       ,height:30 , visible:true                
	                    	, renderer : 
	                        {
	                            type : "CheckBoxEditRenderer",
	                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
	                            checkValue : "1347", // true, false 인 경우가 기본
	                            unCheckValue : ""
	                           
	                        }
	                                  
	                    },
                        	{dataField: "MKT",headerText :"<spring:message code='log.head.merchandiseitem'/>"            ,width:    "8%"       ,height:30 , visible:true                
	                    	, renderer : 
	                        {
	                            type : "CheckBoxEditRenderer",
	                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
	                            checkValue : "1346", // true, false 인 경우가 기본
	                            unCheckValue : ""
	                           
	                        }
	                                  
	                    },
                        	{dataField: "KSK",headerText :"<spring:message code='log.head.kioskitem'/>"                ,width:  "8%"       ,height:30 , visible:true 
	                    	, renderer : 
	                        {
	                            type : "CheckBoxEditRenderer",
	                            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
	                            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
	                            checkValue : "1345", // true, false 인 경우가 기본
	                            unCheckValue : ""
	                            
	                         }
	                    }
                       ];
    
    var gridoptions = {showStateColumn : false , editable : false, pageRowCount : 30, usePaging : true, useGroupingPanel : false , fixedColumnCount:2};
    

    $(document).ready(function(){
        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);
        
        doGetCombo('/common/selectCodeList.do', '63', '','spgroup', 'A' , ''); 
        doDefCombo(comboData, '' ,'sused', 'A', '');
        
        AUIGrid.bind(myGridID, "cellClick", function( event ) 
        {   
        });

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
        {
        	$("#insertView").hide();
        	f_detailView(event.rowIndex);
        });
        
        AUIGrid.bind(myGridID, "ready", function(event) {
        	var rowCount = AUIGrid.getRowCount(myGridID);  
        	
        	for (var i = 0 ; i < rowCount ; i++){
        		var itemtype = AUIGrid.getCellValue(myGridID, i, "itemType");
        		
        		if (itemtype != null && itemtype != "" && itemtype != undefined){
        			
        			var typeArr = itemtype.split(",");
        			for (var j = 0 ; j < typeArr.length ; j++){
        				
        				$.each(itemdata, function(index,value) {
        					if(typeArr[j] == itemdata[index].codeId ){
        						AUIGrid.setCellValue(myGridID, i, itemdata[index].code , typeArr[j]);
        					}
       			        });
        				
        			}
        		}
        	}
        	AUIGrid.resetUpdatedItems(myGridID, "all");
        });
        
         $("#detailView").hide();
         $("#insertView").hide();
         getMaterialListAjax("");

    });

    $(function(){
    	$('#svalue').keypress(function(event) {
    		if (event.which == '13') {
            	$("#sUrl").val("/logistics/material/materialcdsearch.do");
            	Common.searchpopupWin("searchForm", "/common/searchPopList.do","item");
            }
        });
    	//insert
		$('#insprice').keypress(function() {
		    if (event.which == '13') {
		        var findStr=".";
		        var sublen;
		        var prices = $("#insprice").val();
		        var priceslen=prices.length;
		        //alert("????"+prices.indexOf(findStr));
		        if (prices.indexOf(findStr) > 0) {	
		          sublen= prices.indexOf('.');
                  sublen=sublen+1;
                  var sums = priceslen - sublen;
                //  alert("sums :  "+sums);
                  if(sums == 0 ){
                	  $("#insprice").val(prices+"00");  
                  }else if(sums == 1 ){
                      $("#insprice").val(prices+"0");  
                  }else if(sums == 2){
                	    
                  }else{
                	  Common.alert("Please enter only the second decimal place.");
                	  $("#insprice").val("");
                  }
                 
			      }else if(prices.indexOf(findStr) == 0){
			    	  Common.alert('You can not enter decimal numbers first.');
			    	  $("#insprice").val("");
			      }else{
			    	//  alert('Not Found!!');
	                  $("#insprice").val($.number(prices,2));  
			      } 
	
		    }
		});
	    //update
		$('#price').keypress(function() {
            if (event.which == '13') {
                var findStr=".";
                var sublen;
                var prices = $("#price").val();
                var priceslen=prices.length;
                //alert("????"+prices.indexOf(findStr));
                if (prices.indexOf(findStr) > 0) {  
                  sublen= prices.indexOf('.');
                  sublen=sublen+1;
                  var sums = priceslen - sublen;
                //  alert("sums :  "+sums);
                  if(sums == 0 ){
                      $("#price").val(prices+"00");  
                  }else if(sums == 1 ){
                      $("#price").val(prices+"0");  
                  }else if(sums == 2){
                        
                  }else{
                      Common.alert("Please enter only the second decimal place.");
                      $("#price").val("");
                  }
                 
                  }else if(prices.indexOf(findStr) == 0){
                      Common.alert('You can not enter decimal numbers first.');
                      $("#price").val("");
                  }else{
                    //  alert('Not Found!!');
                      $("#price").val($.number(prices,2));  
                  } 
    
            }
        });
		
		

    	$("#search").click(function(){
            getMaterialListAjax("");
            $("#detailView").hide();
        });
        $("#clear").click(function(){
            doGetCombo('/common/selectCodeList.do', '63', '','spgroup', 'A' , ''); 
            doDefCombo(comboData, '' ,'sused', 'A', '');
            $("#svalue").val('');

        });
        $("#update").click(function(){
            var updCnt = GridCommon.getEditData(myGridID).update.length;
            for (var i = 0 ; i < updCnt ; i++){
                var make = GridCommon.getEditData(myGridID).update[i];
                
                var itemtypevalue = "";
                if (make.CDTL != undefined && make.CDTL != ""){
                	if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.CDTL; 
                }
                if (make.FINI != undefined && make.FINI != ""){
                	if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.FINI; 
                }if (make.HRI != undefined && make.HRI != ""){
                	if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.HRI; 
                }
                if (make.KSK != undefined && make.KSK != ""){
                	if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.KSK; 
                }if (make.MKT != undefined && make.MKT != ""){
                	if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.MKT; 
                }
                if (make.MISC != undefined && make.MISC != ""){
                	if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.MISC; 
                }if (make.PRD != undefined && make.PRD != ""){
                	if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.PRD; 
                }
                if (make.UNM != undefined && make.UNM != ""){
                	if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.UNM; 
                }
                var rows = AUIGrid.getRowIndexesByValue(myGridID, "itmId", make.itmId);
                
                AUIGrid.setCellValue(myGridID, rows, "itemType" , itemtypevalue);
            }
            
        	Common.ajax("POST", "/logistics/material/materialUpdateItemType.do", GridCommon.getEditData(myGridID), function(result) {
                Common.alert(result.message);
                AUIGrid.resetUpdatedItems(myGridID, "all");
                
            },  function(jqXHR, textStatus, errorThrown) {
                try {
                } catch (e) {
                }

                Common.alert("Fail : " + jqXHR.responseJSON.message);
            });
        	getMaterialListAjax("");
        });
        $(".numberAmt").keyup(function(e) {
            regex = /[^.0-9]/gi;
            v = $(this).val();
            if (regex.test(v)) {
                var nn = v.replace(regex, '');
                $(this).val(v.replace(regex, ''));
                $(this).focus();
                return;
            }
        });
        $("#delete").click(function(){ 
        	var selectedItems = AUIGrid.getSelectedIndex(myGridID);
        	  if (selectedItems[0] > -1){
        		  f_deleteView(selectedItems[0]);
              }else{
              Common.alert('Choice Data please..');
              }
        });
        
        
        $("#detailsave").click(function(){
        	
        	if (valiedcheck()){
            	var rows = AUIGrid.getRowIndexesByValue(myGridID, "itmId", $("#ditmid").val());
            	var checkval = "";
                $("input[id=itemtype]:checked").each(function() {
                    if (checkval != "") checkval += ",";
                    checkval += $(this).val();                
                });
            	AUIGrid.setCellValue(myGridID, rows, "itemType"   , checkval);
            	AUIGrid.setCellValue(myGridID, rows, "itmName"    , $("#itmname").val());
            	AUIGrid.setCellValue(myGridID, rows, "prc"        , $("#price").val());
            	AUIGrid.setCellValue(myGridID, rows, "itmDesc"    , $("#itmdesc").val());
            	AUIGrid.setCellValue(myGridID, rows, "oldStkId"   , $("#olditemid").val());
            	AUIGrid.setCellValue(myGridID, rows, "uom"        , $("#uom").val());
            	AUIGrid.setCellValue(myGridID, rows, "currency"   , $("#currency").val());
            	AUIGrid.setCellValue(myGridID, rows, "ctgryId"    , $("#cateid").val());
            	AUIGrid.setCellValue(myGridID, rows, "stusCodeId" , $("#stuscode").val());
            	Common.ajax("POST", "/logistics/material/materialUpdateItemType.do", GridCommon.getEditData(myGridID), function(result) {
                    Common.alert(result.message);
                    AUIGrid.resetUpdatedItems(myGridID, "all");
                    
                },  function(jqXHR, textStatus, errorThrown) {
                    try {
                    } catch (e) {
                    }

                    Common.alert("Fail : " + jqXHR.responseJSON.message);
                });
            	getMaterialListAjax(rows);
            }
        	
        });
              
        
        $("#detailcancel").click(function(){
        	var rows = AUIGrid.getRowIndexesByValue(myGridID, "itmId", $("#ditmid").val());
        	f_detailView(rows);
        });
        
         $("#insert").click(function(){
            f_insertView();
        });
         
         $("#insertsave").click(function(){
             
             if (insvaliedcheck()){
            	var checkval = "";
                $("input[id=insitemtype]:checked").each(function() {
                    if (checkval != "") checkval += ",";
                    checkval += $(this).val();
                });
                $('[name="insitemtype"]').val(checkval);        	
                  var param = $('#insertForm').serializeJSON();
                  Common.ajax("POST", "/logistics/material/materialInsertItemType.do",param, function(result) {
                     Common.alert(result.message);
                     $('#insertForm')[0].reset();
                 },  function(jqXHR, textStatus, errorThrown) {
                     try {
                     } catch (e) {
                     }

                     Common.alert("Fail : " + jqXHR.responseJSON.message);
                 });
             }             
         });
         
         $("#cancelinsert").click(function(){
        	 $("#insertView").hide();
        	 $('#insertForm')[0].reset();
         });
         
         
         
    });
    
    function f_detailView(rid){
    	$("#detailView").show();
        var seldata = AUIGrid.getItemByRowIndex(myGridID , rid);
        
        doGetCombo('/common/selectCodeList.do', '63', seldata.ctgryId  ,'cateid', 'S' , '');
        doGetCombo('/common/selectCodeList.do', '94', seldata.currency ,'currency', 'S' , '');
        doGetCombo('/common/selectCodeList.do', '42', seldata.uom      ,'uom', 'S' , '');
        doDefCombo(comboData, seldata.stusCodeId ,'stuscode', 'S', '');
        $("#itmcode").val(seldata.itmCode);
        $("#itmname").val(seldata.itmName);
        $("#itmdesc").val(seldata.itmDesc);
        $("#olditemid").val(seldata.oldStkId);
        $("#price").val(seldata.prc);
        $("#ditmid").val(seldata.itmId);
        //itemtypedata
        var html = "";
        var checked = "";
        $.each(itemdata, function(index,value) {
            if (index == 0 || (index % 4) == 0){
                html += "<tr>";
            }
            
            if (seldata.itemType != null && seldata.itemType != "" && seldata.itemType != undefined){
                var typeArr = seldata.itemType.split(",");
                for (var j = 0 ; j < typeArr.length ; j++){
                    if(typeArr[j] == itemdata[index].codeId ){
                        checked = "checked";
                    }
                }
            }
            
            html += "<th scope=\"row\">"+itemdata[index].codeName+"</th>";
            html += "<td>";
            html += "<label><input type=\"checkbox\" id='itemtype' name='itemtype' value='"+itemdata[index].codeId+"' "+checked+"/></label>";
            html += "</td>";
            
            if ((index % 4) == 3){
                html += "</tr>";
            }
            checked = "";
        });
        
        $("#itemtypedata").html(html);
    }
    
    function valiedcheck(){
    	if($("#uom").val() == ""){
            Common.alert("Please select one of Unit of Measure.");
            $("#uom").focus();
            return false;
        }
        if($("#currency").val() == ""){
            Common.alert("Please select one of Currency.");
            $("#currency").focus();
            return false;
        }
        if($("#cateid").val() == ""){
            Common.alert("Please select one of Key Product Group.");
            $("#cateid").focus();
            return false;
        }
        if($("#stuscode").val() == ""){
            Common.alert("Please select one of Used.");
            $("#stuscode").focus();
            return false;
        }
        if($("#price").val() == ""){
            Common.alert("Please enter the Sales Price.");
            $("#price").focus();
            return false;
        }
        if($("#itmname").val() == ""){
            Common.alert("Please enter the Material Name.");
            $("#itmname").focus();
            return false;
        }
        
        
        if($("input[id=itemtype]:checked").length == 0){
            Common.alert("Please check one or more Item Type.");
            return false;
        }
        return true;
    }
    
    function insvaliedcheck(){
    	if($("#insitmname").val() == ""){
               Common.alert("Please enter the Material Name.");
               $("#insitmname").focus();
               return false;
        }
        if($("#insuom").val() == ""){
            Common.alert("Please select one of Unit of Measure.");
            $("#insuom").focus();
            return false;
        }
        if($("#inscurrency").val() == ""){
            Common.alert("Please select one of Currency.");
            $("#inscurrency").focus();
            return false;
        }
        if($("#inscateid").val() == ""){
            Common.alert("Please select one of Key Product Group.");
            $("#inscateid").focus();
            return false;
        }
        if($("#insstuscode").val() == ""){
            Common.alert("Please select one of Used.");
            $("#insstuscode").focus();
            return false;
        }
        if($("#insprice").val() == ""){
            Common.alert("Please enter the Sales Price.");
            $("#insprice").focus();
            return false;
        }
     
        
        if($("input[id=insitemtype]:checked").length == 0){
            Common.alert("Please check one or more Item Type.");
            return false;
        }
        return true;
    }
    function fn_itempopList(data){
    	doGetCombo('/common/selectCodeList.do', '63', data[0].item.cateid ,'spgroup', 'A' , '');
    	$("#svalue").val(data[0].item.itemcode);
        $("#sname").text(data[0].item.itemname);
    }
    
    function fn_itempop(cd , nm , ct , tp){
    	doGetCombo('/common/selectCodeList.do', '63', ct ,'spgroup', 'A' , '');
    	$("#svalue").val(cd);
        $("#sname").text(nm);
    }
    
    function getMaterialListAjax(rid) {
        
        var url = "/logistics/material/materialitemList.do";
        var param = $('#searchForm').serializeJSON();
        $.ajax({
            type : "GET",
            url : "/common/selectCodeList.do",
            data : { groupCode : "141"},
            dataType : "json",
            contentType : "application/json;charset=UTF-8",
            success : function(data) {
                itemdata = data;
            },
            error: function(jqXHR, textStatus, errorThrown){
            },
            complete: function(){
            }
        });
        console.log(param);
        Common.ajax("POST" , url , param , function(data){
        	
            
            AUIGrid.setGridData(myGridID, data.data);
        
            if (rid != ""){
            	AUIGrid.setSelectionByIndex(myGridID, rid, 3);
            	f_detailView(rid);
            }
        });
    }
    
    function f_showModal(){
        $.blockUI.defaults.css = {textAlign:'center'}
        $('div.SalesWorkDiv').block({
                message:"<img src='/resources/images/common/CowayLeftLogo.png' alt='Coway Logo' style='max-height: 46px;width:160px' /><div class='preloader'><i id='iloader'>.</i><i id='iloader'>.</i><i id='iloader'>.</i></div>",
                centerY: false,
                centerX: true,
                css: { top: '300px', border: 'none'} 
        });
    }
    function hideModal(){
        $('div.SalesWorkDiv').unblock();
        
    }
    
    
    function f_insertView(){
    	$("#detailView").hide();
        $("#insertView").show();
  
        doGetCombo('/common/selectCodeList.do', '63','','inscateid', 'S' , '');
        doGetCombo('/common/selectCodeList.do', '42', ''     ,'insuom', 'S' , '');
        doGetCombo('/common/selectCodeList.do', '94', '','inscurrency', 'S' , '');
        doDefCombo(comboData, '' ,'insstuscode', 'S', '');

        var html = "";
        var checked = "";
        $.each(itemdata, function(index,value) {
            if (index == 0 || (index % 4) == 0){
                html += "<tr>";
            }
            
            html += "<th scope=\"row\">"+itemdata[index].codeName+"</th>";
            html += "<td>";
            html += "<label><input type=\"checkbox\" id='insitemtype' name='insitemtype' value='"+itemdata[index].codeId+"' "+checked+"/></label>";
            html += "</td>";
            
            if ((index % 4) == 3){
                html += "</tr>";
            }
            checked = "";
        });
        
        $("#insitemtypedata").html(html);   
    }
     
    
    function f_deleteView(rowid){
    
        var itmId= AUIGrid.getCellValue(myGridID ,rowid,'itmId');         
                
         var param = "?itmId="+itmId;
          $.ajax({
            type : "POST",
            url : "/logistics/material/materialDeleteItemType.do"+param,
            dataType : "json",               
            contentType : "application/json;charset=UTF-8",
            success : function(result) {
            Common.alert(result.message);
            $("#search").click();
            },
            error: function(jqXHR, textStatus, errorThrown){
                alert("실패하였습니다.");
            }
        });
          
    }    
   
    
    
  
//     function priceValied(prices){
//     	var position = new Array();
//     	var pos = prices.indexOf(".");
//         while(pos > -1){
//             position.push(pos);
//         }
   
//         if(position > 1){
//         	alert("Only one decimal point can be entered.");
//         	$("#insprice").val("");
//         	return false;
//         }else{
//         	return true;
//         }
        
//     } 
     
</script>
<div id="SalesWorkDiv" class="SalesWorkDiv" style="width: 100%; height: 960px; position: static; zoom: 1;">
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Material Master</li>
    <li>Non-Valued Material Code</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Non-Valued Material Code</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm">
<input type="hidden" id="sUrl" name="sUrl">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:165px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Material Code</th>
    <td><input type="text" id="svalue" name="svalue" class="w100p"/><p id='sname'></td>
    <th scope="row">Key Product Group</th>
    <td>
    <select class="w100p" id="spgroup" name="spgroup"></select>
    </td>
    <th scope="row">Used</th>
    <td>
    <select class="w100p" id="sused" name="sused"></select>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">

<%--     <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.excel.up' /></a></p></li> --%>
<%--     <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.excel.dw' /></a></p></li> --%>
    <li><p class="btn_grid"><a id="delete"><spring:message code='sys.btn.del' /></a></p></li>
<%--     <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.ins' /></a></p></li> --%>
    <li><p class="btn_grid"><a id="update"><spring:message code='sys.btn.update' /></a></p></li>
    <li><p class="btn_grid"><a id="insert"><spring:message code='sys.btn.add' /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap"></div>
</article><!-- grid_wrap end -->

<div id="detailView">
<aside class="title_line"><!-- title_line start -->
<h3 id="title">Material Master Create/Change</h3>
</aside>
<form id="detailForm">
<input type="hidden" id="ditmid"/>
<aside class="title_line"><!-- title_line start -->
<h4>Main Value</h4>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:165px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Material Code</th>
    <td>
    <input type="text" placeholder="" id='itmcode' class="readonly w100p" readonly="readonly" />
    </td>
    <th scope="row">Material Name</th>
    <td colspan="3">
    <input type="text" id='itmname' title="" placeholder="" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Description</th>
    <td colspan="5">
    <input type="text" id='itmdesc' title="" placeholder="" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Old Material Number</th>
    <td>
    <input type="text" id='olditemid' placeholder="" class="w100p"  />
    </td>
    <th scope="row">Unit of Measure</th>
    <td>
    <select class="w100p" id="uom">
    </select>
    </td>
    <th scope="row">Currency</th>
    <td>
    <select class="w100p" id="currency">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Key Product Group</th>
    <td>
    <select class="w100p" id="cateid">
    </select>
    </td>
    <th scope="row">Sales Price</th>
    <td>
    <input type="text" placeholder="" id="price" class="w100p numberAmt"/>
    </td>
    <th scope="row">Used</th>
    <td>
    <select class="w100p" id="stuscode">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h4>Item Type</h4>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:200px" />
    <col style="width:*" />
    <col style="width:200px" />
    <col style="width:*" />
    <col style="width:225px" />
    <col style="width:*" />
    <col style="width:200px" />
    <col style="width:*" />
</colgroup>
<tbody id="itemtypedata">

</tbody>
</table><!-- table end -->

<ul class="center_btns mt20">
    <li><p class="btn_blue2"><a id="detailsave">SAVE</a></p></li>
    <li><p class="btn_blue2"><a id="detailcancel">CANCEL</a></p></li>
</ul>


</form>
</div>

<div id="insertView">
<aside class="title_line"><!-- title_line start -->
<h3 id="title">Material Master Create/Change</h3>
</aside>
<form id="insertForm" method="post">
<!-- <input type="text" id="insditmid"/> -->
<aside class="title_line"><!-- title_line start -->
<h4>Main Value</h4>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:165px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Material Code</th>
    <td>
    <input type="text" placeholder=""  class="w100p" disabled="disabled" />
    </td> 
    <th scope="row">Material Name</th>
    <td colspan="3">
    <input type="text" id='insitmname' name='insitmname' title="" placeholder="" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Description</th>
    <td colspan="5">
    <input type="text" id='insitmdesc' name="insitmdesc" title="" placeholder="" class="w100p" />
    </td>
</tr> 
<tr>
    <th scope="row">Old Material Number</th>
    <td>
    <input type="text" id='insolditemid' name="insolditemid" placeholder="" maxlength="15" class="w100p"  />
    </td>
    <th scope="row">Unit of Measure</th>
    <td>
    <select class="w100p" id="insuom" name="insuom">
    </select>
    </td>
    <th scope="row">Currency</th>
    <td>
    <select class="w100p" id="inscurrency" name="inscurrency" >
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Key Product Group</th>
    <td>
    <select class="w100p" id="inscateid" name="inscateid">
    </select>
    </td>
    <th scope="row">Sales Price</th>
    <td>
    <input type="text" placeholder="" id="insprice" name="insprice"  class="numberAmt"/>
    </td>
<!--     <th scope="row">Used</th>
    <td>
    <select class="w100p" id="insstuscode" name="insstuscode">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td> -->
    <td colspan="2"></td>
</tr> 
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h4>Item Type</h4>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:200px" />
    <col style="width:*" />
    <col style="width:200px" />
    <col style="width:*" />
    <col style="width:225px" />
    <col style="width:*" />
    <col style="width:200px" />
    <col style="width:*" />
</colgroup>
<tbody id="insitemtypedata">

</tbody> 
</table><!-- table end -->

<ul class="center_btns mt20">
    <li><p class="btn_blue2"><a id="insertsave">SAVE</a></p></li>
    <li><p class="btn_blue2"><a id="cancelinsert">CANCEL</a></p></li>
</ul>

</form>
</div> 

</section>
