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

.my-row-style {
    background:#9FC93C;
    font-weight:bold;
    color:#22741C;
}
</style>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var myGridID;
var myGridIDHide;
var myGridIDExcel;


var serialGrid;


var adjNo="${rAdjcode }";
var adjLocation = "${rAdjlocId }";

var columnLayout=[
                  {dataField:"rnum" ,headerText:"rnum",width:120 ,height:30 , visible:false ,editable:false },
                  {dataField:"invntryLocId" ,headerText:"invntryLocId",width:120 ,height:30 ,editable:false},
                  {dataField:"invntryNo" ,headerText:"Stock Audit No",width:120 ,height:30 ,editable:false},
                  {dataField:"docDt" ,headerText:"docDt",width:120 ,height:30 ,editable:false},
                  {dataField:"locId" ,headerText:"locId",width:120 ,height:30 ,editable:false},
                  {dataField:"serialPdChk" ,headerText:"serialPdChk",width:120 ,height:30, visible:false ,editable:false},
                  {dataField:"serialFtChk" ,headerText:"serialFtChk",width:120 ,height:30, visible:false ,editable:false},
                  {dataField:"serialPtChk" ,headerText:"serialPtChk",width:120 ,height:30, visible:false ,editable:false},
                  {dataField:"saveYn" ,headerText:"saveYn",width:120 ,height:30, visible:true ,editable:false},
                  {dataField:"seq" ,headerText:"seq",width:120 ,height:30 ,editable:false},
                  {dataField:"itmId" ,headerText:"itmId",width:120 ,height:30 ,editable:false},
                  {dataField:"itmNm" ,headerText:"itmNm",width:120 ,height:30 ,editable:false},
                  {dataField:"itmType" ,headerText:"itmType",width:120 ,height:30 , visible:false ,editable:false},
                  {dataField:"serialChk" ,headerText:"serialChk",width:120 ,height:30 ,editable:false},
                  {dataField:"sysQty" ,headerText:"sysQty",width:120 ,height:30,editable:false},
                  {dataField:"cntQty" ,headerText:"cntQty",width:120 ,height:30,editable : true 
                	  ,dataType : "numeric" ,editRenderer : {
                          type : "InputEditRenderer",
                          onlyNumeric : true, // 0~9 까지만 허용
                          allowPoint : false // onlyNumeric 인 경우 소수점(.) 도 허용
                    }  
                  },
                  {dataField:"diffQty" ,headerText:"Diff Qty",width:120 ,height:30  ,editable:false},
                  {dataField:"stkCode" ,headerText:"stkCode",width:120 ,height:30 , visible:false ,editable:false},
                  {dataField:"stkDesc" ,headerText:"stkDesc",width:120 ,height:30  , visible:false ,editable:false},
                  {dataField:"stkTypeId" ,headerText:"stkTypeId",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"stkCtgryId" ,headerText:"stkCtgryId",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"qty" ,headerText:"qty",width:120 ,height:30, visible:false ,editable:false},
                  {dataField:"movQty" ,headerText:"movQty",width:120 ,height:30, visible:false,editable:false},
                  
                  {dataField:"whLocId" ,headerText:"Location ID",width:"20%" ,height:30, visible:false,editable:false },
                  {dataField:"whLocCode" ,headerText:"Location Code",width:"30%" ,height:30, visible:false,editable:false},
                  {dataField:"whLocDesc" ,headerText:"Location Desc",width:"50%" ,height:30, visible:false,editable:false},
                  {dataField:"whLocTel1" ,headerText:"whLocTel1",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocTel2" ,headerText:"whLocTel2",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocBrnchId" ,headerText:"whLocBrnchId",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocTypeId" ,headerText:"whLocTypeId",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocStkGrad" ,headerText:"whLocStkGrad",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocStusId" ,headerText:"whLocStusId",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocUpdUserId" ,headerText:"whLocUpdUserId",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocUpdDt" ,headerText:"whLocUpdDt",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"code2" ,headerText:"code2",width:120 ,height:30 , visible:false ,editable:false},
                  {dataField:"desc2" ,headerText:"desc2",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocIsSync" ,headerText:"whLocIsSync",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocMobile" ,headerText:"whLocMobile",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"areaId" ,headerText:"areaId",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"addrDtl" ,headerText:"addrDtl",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"street" ,headerText:"street",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocBrnchId2" ,headerText:"whLocBrnchId2",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocBrnchId3" ,headerText:"whLocBrnchId3",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocGb" ,headerText:"whLocGb",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"serialPdChk" ,headerText:"serialPdChk",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"serialFtChk" ,headerText:"serialFtChk",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"serialPtChk" ,headerText:"serialPtChk",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"commonCrChk" ,headerText:"commonCrChk",width:120 ,height:30 , visible:false,editable:false}
                    ];
var columnLayout2=[
                  {dataField:"rnum" ,headerText:"rnum",width:120 ,height:30 , visible:false ,editable:false },
                  {dataField:"invntryLocId" ,headerText:"invntryLocId",width:120 ,height:30 ,editable:false},
                  {dataField:"invntryNo" ,headerText:"Stock Audit No",width:120 ,height:30 ,editable:false},
                  {dataField:"docDt" ,headerText:"docDt",width:120 ,height:30 ,editable:false},
                  {dataField:"locId" ,headerText:"locId",width:120 ,height:30 ,editable:false},
                  {dataField:"serialPdChk" ,headerText:"serialPdChk",width:120 ,height:30, visible:false ,editable:false},
                  {dataField:"serialFtChk" ,headerText:"serialFtChk",width:120 ,height:30, visible:false ,editable:false},
                  {dataField:"serialPtChk" ,headerText:"serialPtChk",width:120 ,height:30, visible:false ,editable:false},
                  {dataField:"saveYn" ,headerText:"saveYn",width:120 ,height:30, visible:false ,editable:false},
                  {dataField:"seq" ,headerText:"seq",width:120 ,height:30 ,editable:false},
                  {dataField:"itmId" ,headerText:"itmId",width:120 ,height:30 ,editable:false},
                  {dataField:"itmNm" ,headerText:"itmNm",width:120 ,height:30 ,editable:false},
                  {dataField:"itmType" ,headerText:"itmType",width:120 ,height:30 , visible:false ,editable:false},
                  {dataField:"serialChk" ,headerText:"serialChk",width:120 ,height:30 ,editable:false},
                  {dataField:"sysQty" ,headerText:"sysQty",width:120 ,height:30,editable:false},
                  {dataField:"cntQty" ,headerText:"cntQty",width:120 ,height:30,editable : true , visible:false
                	  ,dataType : "numeric" ,editRenderer : {
                          type : "InputEditRenderer",
                          onlyNumeric : true, // 0~9 까지만 허용
                          allowPoint : false // onlyNumeric 인 경우 소수점(.) 도 허용
                    }  
                  },
                  {dataField:"inVal" ,headerText:"Serial/CntQty",width:120 ,height:30  ,editable:false},
                  {dataField:"stkCode" ,headerText:"stkCode",width:120 ,height:30 , visible:false ,editable:false},
                  {dataField:"stkDesc" ,headerText:"stkDesc",width:120 ,height:30  , visible:false ,editable:false},
                  {dataField:"stkTypeId" ,headerText:"stkTypeId",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"stkCtgryId" ,headerText:"stkCtgryId",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"qty" ,headerText:"qty",width:120 ,height:30, visible:false ,editable:false},
                  {dataField:"movQty" ,headerText:"movQty",width:120 ,height:30, visible:false,editable:false},
                  
                  {dataField:"whLocId" ,headerText:"Location ID",width:"20%" ,height:30, visible:false,editable:false },
                  {dataField:"whLocCode" ,headerText:"Location Code",width:"30%" ,height:30, visible:false,editable:false},
                  {dataField:"whLocDesc" ,headerText:"Location Desc",width:"50%" ,height:30, visible:false,editable:false},
                  {dataField:"whLocTel1" ,headerText:"whLocTel1",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocTel2" ,headerText:"whLocTel2",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocBrnchId" ,headerText:"whLocBrnchId",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocTypeId" ,headerText:"whLocTypeId",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocStkGrad" ,headerText:"whLocStkGrad",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocStusId" ,headerText:"whLocStusId",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocUpdUserId" ,headerText:"whLocUpdUserId",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocUpdDt" ,headerText:"whLocUpdDt",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"code2" ,headerText:"code2",width:120 ,height:30 , visible:false ,editable:false},
                  {dataField:"desc2" ,headerText:"desc2",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocIsSync" ,headerText:"whLocIsSync",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocMobile" ,headerText:"whLocMobile",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"areaId" ,headerText:"areaId",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"addrDtl" ,headerText:"addrDtl",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"street" ,headerText:"street",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocBrnchId2" ,headerText:"whLocBrnchId2",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocBrnchId3" ,headerText:"whLocBrnchId3",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"whLocGb" ,headerText:"whLocGb",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"serialPdChk" ,headerText:"serialPdChk",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"serialFtChk" ,headerText:"serialFtChk",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"serialPtChk" ,headerText:"serialPtChk",width:120 ,height:30 , visible:false,editable:false},
                  {dataField:"commonCrChk" ,headerText:"commonCrChk",width:120 ,height:30 , visible:false,editable:false}
                    ];
var serialcolumn  =[{dataField:"itmcd"        ,headerText:"Material Code"               ,width:120    ,height:30,visible:false },
                         {dataField:"itmname"      ,headerText:"Material Name"               ,width:120    ,height:30,visible:false },
                         {dataField:"serial"       ,headerText:"Serial"                      ,width:"100%"    ,height:30,editable:true },
                         {dataField:"cnt61"        ,headerText:"Serial"                      ,width:120     ,height:30,visible:false },
                         {dataField:"cnt62"        ,headerText:"Serial"                      ,width:120     ,height:30,visible:false },
                         {dataField:"cnt63"        ,headerText:"Serial"                      ,width:120     ,height:30,visible:false },
                         {dataField:"statustype"   ,headerText:"status"                     ,width:120     ,height:30 }
                        ];                              
var resop = {rowIdField : "rnum"
		, showStateColumn : false 
		, showRowCheckColumn : true 
		,usePaging : false
		//,useGroupingPanel : false 
		,editable:true,
		exportURL : "/common/exportGrid.do"
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
$(document).ready(function(){
	searchHead();
    /**********************************
    * Header Setting
    ***********************************/
    /**********************************
     * Header Setting End
     ***********************************/
     // 최초 그리드 생성함.
     createInitGrid();
     
     // IE10, 11은 readAsBinaryString 지원을 안함. 따라서 체크함.
     var rABS = typeof FileReader !== "undefined" && typeof FileReader.prototype !== "undefined" && typeof FileReader.prototype.readAsBinaryString !== "undefined";

     // HTML5 브라우저인지 체크 즉, FileReader 를 사용할 수 있는지 여부
     function checkHTML5Brower() {
         var isCompatible = false;
         if (window.File && window.FileReader && window.FileList && window.Blob) {
             isCompatible = true;
         }
         return isCompatible;
     };
     
    
    myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", resop);
    //myGridIDHide = GridCommon.createAUIGrid("grid_wrap2", columnLayout2,"", resop);
    serialGrid = AUIGrid.create("#serial_grid_wrap", serialcolumn, serialop);
    
    AUIGrid.bind(myGridID, "addRow", function(event){});
    
    AUIGrid.bind(myGridID, "cellEditBegin", function (event){});
        
    
    AUIGrid.bind(myGridID, "cellEditEnd", function (event){
    	var selectedItem = AUIGrid.getSelectedIndex(myGridID);
        var qty = AUIGrid.getCellValue(myGridID , selectedItem[0] , 'sysQty') - AUIGrid.getCellValue(myGridID ,selectedItem[0] , 'cntQty');
        AUIGrid.setCellValue(myGridID, selectedItem[0], 'diffQty', qty);
    	
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
            f_addrow(); 
           /* if($("#serialqty").val() > AUIGrid.getRowCount(serialGrid)){
              f_addrow();      
           } */
           
        } 
    });
        
    
    AUIGrid.bind(myGridID, "cellClick", function( event ) {});
    
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event){
    	var serialChk=AUIGrid.getCellValue(myGridID, event.rowIndex, "serialChk");
    	var invntryLocId=AUIGrid.getCellValue(myGridID, event.rowIndex, "invntryLocId");
    	var invntryNo=AUIGrid.getCellValue(myGridID, event.rowIndex, "invntryNo");
    	var seq=AUIGrid.getCellValue(myGridID, event.rowIndex, "seq");
    	var stkCode=AUIGrid.getCellValue(myGridID, event.rowIndex, "stkCode");
    	var locId=AUIGrid.getCellValue(myGridID, event.rowIndex, "locId");

    	if(serialChk=="Y"){
            $("#giopenwindow").show();
            $("#adjLocIdPop").val(invntryLocId);
            $("#adjnoPop").val(invntryNo);
            $("#adjItemPop").val(seq);
            $("#mtrCdPop").val(stkCode);
            $("#locPop").val(locId);
            AUIGrid.clearGridData(serialGrid);
            AUIGrid.resize(serialGrid); 
            f_addrow();
    	}else{
    		
    	}
    	
    	
    });
    
    AUIGrid.bind(myGridID, "ready", function(event) {
    	
    	var rowCnt = AUIGrid.getRowCount(myGridID);
        for (var i = 0 ; i < rowCnt ; i++){
            var qty = AUIGrid.getCellValue(myGridID , i , 'sysQty') - AUIGrid.getCellValue(myGridID , i , 'cntQty');
            console.log(qty);
           // if(AUIGrid.getCellValue(myGridID , i , 'cntQty'))
            AUIGrid.setCellValue(myGridID, i, 'diffQty', qty);
        }
        AUIGrid.resetUpdatedItems(myGridID, "all");
    });
    
    
    $('#fileSelector').on('change', function(evt) {
        if (!checkHTML5Brower()) {
            alert("브라우저가 HTML5 를 지원하지 않습니다.\r\n서버로 업로드해서 해결하십시오.");
            return;
        } else {
            var data = null;
            var file = evt.target.files[0];
            if (typeof file == "undefined") {
                alert("파일 선택 시 오류 발생!!");
                return;
            }
            var reader = new FileReader();

            reader.onload = function(e) {
                var data = e.target.result;

                /* 엑셀 바이너리 읽기 */
                
                var workbook;

                if(rABS) { // 일반적인 바이너리 지원하는 경우
                    workbook = XLSX.read(data, {type: 'binary'});
                } else { // IE 10, 11인 경우
                    var arr = fixdata(data);
                    workbook = XLSX.read(btoa(arr), {type: 'base64'});
                }

                var jsonObj = process_wb(workbook);
                //console.log(jsonObj);
                //console.log(JSON.stringify(jsonObj.Sheet1, 2, 2));
                
                createAUIGrid( jsonObj[Object.keys(jsonObj)[0]] );
            };

            if(rABS) reader.readAsBinaryString(file);
            else reader.readAsArrayBuffer(file);
            
        }
    });
    
});

//btn clickevent
$(function(){
    
    $('#list').click(function() {
        document.listForm.action = '/logistics/adjustment/NewAdjustmentRe.do';
        document.listForm.submit();
    });
    $('#confirm').click(function() {
    	fn_confirm();
    });
    $('#savePop').click(function() {
    	giFunc();
    });
    $('#saveExcel').click(function() {
    	//giFunc();
    	fn_excelSave();
    	
    });
    $('#excelUp').click(function() {
    	//$("#fileSelector").text(" ");
    	$('input[type=file]').val('');
    	AUIGrid.clearGridData(myGridIDExcel);
    	$("#popup_wrap_excel_up").show();
    });
    $('#excelDown').click(function() {
        // 그리드의 숨겨진 칼럼이 있는 경우, 내보내기 하면 엑셀에 아예 포함시키지 않습니다.
        // 다음처럼 excelProps 에서 exceptColumnFields 을 지정하십시오.
        
        var excelProps = {
                
        	fileName     : $("#adjno").val()+"_"+$("#txtlocCode").text(),
            sheetName : $("#txtlocCode").text(),
            
            //exceptColumnFields : ["docDt","locId","seq", "cntQty"], // 이름, 제품, 컬러는 아예 엑셀로 내보내기 안하기.
            
             //현재 그리드의 히든 처리된 칼럼의 dataField 들 얻어 똑같이 동기화 시키기
           exceptColumnFields : AUIGrid.getHiddenColumnDataFields(myGridID) 
        };
        
        //AUIGrid.exportToXlsx(myGridIDHide, excelProps);
        AUIGrid.exportToXlsx(myGridID, excelProps);
        //GridCommon.exportTo("grid_wrap", "xlsx", "test");
    });
    
    $('#save').click(function() {
           	var param = GridCommon.getEditData(myGridID);
           	console.log(param);
            Common.ajax("POST", "/logistics/adjustment/adjustmentLocCount.do", param, function(result) {
                //Common.alert(result.message);
                //AUIGrid.resetUpdatedItems(reqGrid, "all");
            },  function(jqXHR, textStatus, errorThrown) {
                try {
                } catch (e) {
                }
    
                Common.alert("Fail : " + jqXHR.responseJSON.message);
                });
    });
    
});



function searchHead(){
	//var adjNo="${rAdjcode }";
    //var adjLocation = "${rAdjlocId }";
    var param ="adjNo="+adjNo;
    var url = "/logistics/adjustment/oneAdjustmentNo.do";
    Common.ajax("GET" , url , param , function(result){
        var data = result.dataList;
        console.log(data);
        //fn_setVal(data,status);
        fn_setVal(data);
/*         $("#invntryNo").val(data[0].invntryNo);
        $("#autoFlag").val(data[0].autoFlag);
        $("#eventType").val(data[0].eventType);
        $("#itmType").val(data[0].itmType);
        $("#bsadjdate").text(data[0].baseDt);
        $("#doctext").text(data[0].headTitle); */
        set_subGrid(adjNo,adjLocation);
    });
}

function set_subGrid(adjNo,adjLocation){
	 var url = "/logistics/adjustment/adjustmentCountingDetail.do";
	    $.ajax({
	        type : "GET",
	        url : url,
	        data : {
	            adjNo    : adjNo,
	            adjLocation     : adjLocation
	        },
	        dataType : "json",
	        contentType : "application/json;charset=UTF-8",
	        success : function(data) {
	        var data = data.dataList;
	        $("#txtlocCode").text(data[0].whLocId+"-"+data[0].whLocCode);
	        $("#txtlocName").text(data[0].whLocDesc);
	        AUIGrid.setGridData(myGridID, data);
	        AUIGrid.setGridData(myGridIDHide, data);
	        },
	        error : function(jqXHR, textStatus, errorThrown) {
	        },
	        complete : function() {
	        }
	    });
	    
}
function fn_setVal(data){
	//var status = "${rStatus }";
	$("#adjno").val(data[0].invntryNo);
    $("#bsadjdate").text(data[0].baseDt);
    $("#doctext").text(data[0].headTitle);
	var tmp = data[0].eventType.split(',');
	var tmp2 = data[0].itmType.split(',');
	var tmp3 = data[0].ctgryType.split(',');
	fn_eventSet(tmp);
	if(data[0].autoFlag == "A"){
		$("#auto").attr("checked", true);
	}else if(data[0].autoFlag == "M"){
			$("#manual").attr("checked", true);
	}
	fn_itemSet(tmp2);
    fn_itemSet(tmp2,"item");
    fn_itemSet(tmp3,"catagory");
	
	
	
}
function fn_eventSet(tmp){
	for(var i=0; i<tmp.length;i++){
        if(tmp[i]=="1"){
            $("#cdc").attr("checked", true);
        }else if (tmp[i]=="2") {
            $("#rdc").attr("checked", true);
        } else if(tmp[i]=="30"){
            $("#ctcd").attr("checked", true);  
        }
    } 
	
}

function fn_itemSet(tmp,str){
    var no;
    if(str=="item"){
        no=15;
    }else if(str=="catagory"){
        no=11;
    }
    var url = "/logistics/adjustment/selectCodeList.do";
	$.ajax({
        type : "GET",
        url : url,
        data : {
            groupCode : no
        },
        dataType : "json",
        contentType : "application/json;charset=UTF-8",
        success : function(data) {
        	 fn_itemChck(data,tmp,str);
        },
        error : function(jqXHR, textStatus, errorThrown) {
        },
        complete : function() {
        }
    });
}
function  fn_itemChck(data,tmp2,str){
    var obj;
    if(str=="item"){
        obj ="itemtypetd";
    }else if(str=="catagory"){
        obj ="catagorytypetd";
    }
    obj= '#'+obj;
	
	$.each(data, function(index,value) {
	            $('<label />',{id:data[index].code}).appendTo(obj);
	            $('<input />',  {type : 'checkbox',value : data[index].codeId, id : data[index].codeId}).appendTo('#'+data[index].code).attr("disabled","disabled");
	            $('<span />',  {text:data[index].codeName}).appendTo('#'+data[index].code);
	    });
			
		for(var i=0; i<tmp2.length;i++){
			$.each(data, function(index,value) {
				if(tmp2[i]==data[index].codeId){
					$('#'+data[index].codeId).attr("checked", "true");
				}
			});
		}
}


function f_addrow(){
    var rowPos = "last";
    var item = new Object();
    AUIGrid.addRow(serialGrid, item, rowPos);
    return false;
}

function fn_serialChck(rowindex , rowitem , str){
    var schk = true;
    //var ichk = true;
    var slocid = '';//session.locid;
    //var data = { serial : str , locid : slocid};
    var data ;
    var url="/logistics/adjustment/checkSerial.do";
   // data = GridCommon.getEditData(serialGrid);
    data = $("#giForm").serializeJSON();
    $.extend(data, {
        'serial' : str
    });
    Common.ajaxSync("POST", url, data, function(result) {
    	var data=result.dataList;
         if (data[0] == null){
            AUIGrid.setCellValue(serialGrid , rowindex , "itmcd" , "" );
            AUIGrid.setCellValue(serialGrid , rowindex , "itmname" , "" );
            AUIGrid.setCellValue(serialGrid , rowindex , "cnt61" , 0 );
            AUIGrid.setCellValue(serialGrid , rowindex , "cnt62" , 0 );
            AUIGrid.setCellValue(serialGrid , rowindex , "cnt63" , 0 );
            
            schk = false;
            //ichk = false;
            
        }else{
             AUIGrid.setCellValue(serialGrid , rowindex , "itmcd" ,data[0].STKCODE );
             AUIGrid.setCellValue(serialGrid , rowindex , "itmname" ,data[0].STKDESC );
             AUIGrid.setCellValue(serialGrid , rowindex , "cnt61" ,data[0].L61CNT );
             AUIGrid.setCellValue(serialGrid , rowindex , "cnt62" ,data[0].L62CNT );
             AUIGrid.setCellValue(serialGrid , rowindex , "cnt63" ,data[0].L63CNT );
             
    /*          if (data[0].L61CNT > 0 ||data[0].L62CNT == 0 ||data[0].L63CNT > 0){
                 schk = false;
             }else{
                 schk = true;
             } */
                 schk = true;
                 //ichk = true;
             
             //var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
             
            /*  for (var i = 0 ; i < checkedItems.length ; i++){
                 if (data[0].STKCODE == checkedItems[i].itmcd){
                     AUIGrid.setCellValue(serialGrid , rowindex , "statustype" , 'Y' );
                     ichk = true;
                     break;
                 }else{
                     ichk = false;
                 }
             } */
        } 
         
         //if (schk && ichk){
         if (schk){
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

function giFunc(){
    var data ={};
    var serials     = AUIGrid.getAddedRowItems(serialGrid);
    var selectedItem = AUIGrid.getSelectedIndex(myGridID);
    AUIGrid.setCellValue(myGridID , selectedItem[0] , "cntQty" , AUIGrid.getRowCount(serialGrid)-1 );
   /*  for (var i = 0 ; i < AUIGrid.getRowCount(serialGrid) ; i++){
        if (AUIGrid.getCellValue(serialGrid , i , "statustype") == 'N'){
            Common.alert("Please check the serial.")
            return false;
        }
        
        if (AUIGrid.getCellValue(serialGrid , i , "serial") == undefined || AUIGrid.getCellValue(serialGrid , i , "serial") == "undefined"){
            Common.alert("Please check the serial.")
            return false;
        }
    } */
    
    data.add = serials;
    data.form    = $("#giForm").serializeJSON();
    
    console.log(data);
    Common.ajax("POST", "/logistics/adjustment/adjustmentSerialSave.do", data, function(result) {
       
            //Common.alert(result.message , SearchListAjax);
            AUIGrid.resetUpdatedItems(myGridID, "all");    
        $("#giopenwindow").hide();
       // $('#search').click();
       set_subGrid(adjNo,adjLocation);

    },  function(jqXHR, textStatus, errorThrown) {
        try {
        } catch (e) {
        }
        Common.alert("Fail : " + jqXHR.responseJSON.message);
    });
}


function fn_excelSave(){
	var param  =  {};
	param.add = AUIGrid.exportToObject("#popup_wrap_excel");
    Common.ajax("POST", "/logistics/adjustment/saveExcelGrid.do",param , function(result) {
        console.log("data : " + result);
        set_subGrid(adjNo,adjLocation);
    },  function(jqXHR, textStatus, errorThrown) {
        try {
            console.log("status : " + jqXHR.status);
            console.log("code : " + jqXHR.responseJSON.code);
            console.log("message : " + jqXHR.responseJSON.message);
            console.log("detailMessage : "
                    + jqXHR.responseJSON.detailMessage);
        } catch (e) {
            console.log(e);
        }

        alert("Fail : " + jqXHR.responseJSON.message);
    });
	$("#popup_wrap_excel_up").hide();
	
}

//IE10, 11는 바이너리스트링 못읽기 때문에 ArrayBuffer 처리 하기 위함.
function fixdata(data) {
    var o = "", l = 0, w = 10240;
    for(; l<data.byteLength/w; ++l) o+=String.fromCharCode.apply(null,new Uint8Array(data.slice(l*w,l*w+w)));
    o+=String.fromCharCode.apply(null, new Uint8Array(data.slice(l*w)));
    return o;
};

// 파싱된 시트의 CDATA 제거 후 반환.
function process_wb(wb) {
    var output = "";
    output = JSON.stringify(to_json(wb));
    output = output.replace( /<!\[CDATA\[(.*?)\]\]>/g, '$1' );
    return JSON.parse(output);
};

// 엑셀 시트를 파싱하여 반환
function to_json(workbook) {
    var result = {};
    workbook.SheetNames.forEach(function(sheetName) {
        var roa = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName],{defval:""});
        if(roa.length >= 0){
            result[sheetName] = roa;
        }
    });
    return result;
}

// 엑셀 파일 시트에서 파싱한 JSON 데이터 기반으로 그리드 동적 생성
function createAUIGrid(jsonData) {
    if(AUIGrid.isCreated(myGridIDExcel)) {
        AUIGrid.destroy(myGridIDExcel);
        myGridIDExcel = null;
    }
    
    var columnLayout = [];

    // 현재 엑셀 파일의 0번째 행을 기준으로 컬럼을 작성함.
    // 만약 상단에 문서 제목과 같이 있는 경우
    // 조정 필요.
    var firstRow = jsonData[0];

    if(typeof firstRow == "undefined") {
        alert("AUIGrid 로 변환할 수 없는 엑셀 파일입니다.");
        return;
    }

    $.each(firstRow, function(n,v) {
        columnLayout.push({
            dataField : n,
            headerText : n,
            width : 100
        });
    });
    
    // 그리드 생성
    myGridIDExcel = AUIGrid.create("#popup_wrap_excel", columnLayout);
    
    // 그리드에 데이터 삽입
    AUIGrid.clearGridData(myGridIDExcel);
    AUIGrid.setGridData(myGridIDExcel, jsonData);

};


//최초 그리드 생성..
function createInitGrid() {
    
    var columnLayout = [];
    
    for(var i=0; i<20; i++) {
        columnLayout.push({
            dataField : "f" + i,
            headerText : String.fromCharCode(65 + i),
            width : 80
        });
    }
    
    // 그리드 속성 설정
    var gridPros = {
        noDataMessage : "로컬 PC의 엑셀 파일을 선택하십시오."
    };

    // 실제로 #grid_wrap 에 그리드 생성
    myGridIDExcel = AUIGrid.create("#popup_wrap_excel", columnLayout, gridPros);
    
    // 그리드 최초에 빈 데이터 넣음.
    AUIGrid.setGridData(myGridIDExcel, []);
    AUIGrid.resize(myGridIDExcel,1203);
}


function fn_confirm(){
    var param =
    {
    		adjNo    : adjNo,
    		adjLocation     : adjLocation
   };
		Common.ajax("GET", "/logistics/adjustment/adjustmentConfirm.do", param, function(result) {
		       
	        //Common.alert(result.message , SearchListAjax);
	        AUIGrid.resetUpdatedItems(myGridID, "all");    
	    $("#giopenwindow").hide();
	   // $('#search').click();
	   set_subGrid(adjNo,adjLocation);
	
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
    <li>Count-Stock Audit</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Count-Stock Audit</h2>
</aside><!-- title_line end -->

<aside class="title_line"><!-- title_line start -->
<h3>Header Info</h3>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="list"><span class="list"></span>List</a></p></li>
  <li><p class="btn_blue"><a id="confirm"><span class="confirm"></span>Confirm</a></p></li>  
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="headForm" name="headForm" method="POST">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Stock Audit Number</th>
    <td><input id="adjno" name="adjno" type="text" title=""  class="w100p" readonly="readonly" /></td>
    <th scope="row">Auto/Manual</th>
    <td> 
         <label><input type="radio" name="auto" id="auto"    disabled="disabled" /><span>Auto</span></label>
         <label><input type="radio" name="manual" id="manual"   disabled="disabled" /><span>Manual</span></label>        
    </td>
</tr>
<tr>
    <th scope="row">Event Type</th>
    <td>
     <label><input type="checkbox" disabled="disabled" id="cdc" name="cdc"/><span>CDC</span></label>
     <label><input type="checkbox" disabled="disabled" id="rdc" name="rdc"/><span>RDC</span></label>
     <label><input type="checkbox" disabled="disabled" id="ctcd" name="ctcd"/><span>CT/CODY</span></label>
    </td>
    <th scope="row">Items Type</th>
    <td id="itemtypetd">
    </td>
    </tr>
         <tr>
         <th scope="row">Category Type</th>
    <td id="catagorytypetd" colspan="3">
     </tr>
    <tr>
    <th scope="row">Stock Audit Date</th>
    <td id="bsadjdate">
    </td>  
    <td colspan="2"/> 
    </tr>
    <tr>
        <th scope="row">Remark</th>
        <td colspan='3' id="doctext"><!-- <input type="text" name="doctext" id="doctext" class="w100p"  readonly="readonly"/> --></td>
    </tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Location Info</h3>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" >
<input type="hidden" name="srchcdc" id="srchcdc" />  
<input type="hidden" name="srchrdc" id="srchrdc" />  
<input type="hidden" name="srchctcd" id="srchctcd" />  

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:90px" />
</colgroup>
<tbody>
<tr>
    <th scope="row">AdjustmStock Audition Code</th>
    <td id="txtlocCode">
    </td>
    <th scope="row">Stock Audit  Location Name</th>
    <td id="txtlocName">
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->
	<ul class="right_btns">

		<li><p class="btn_grid">
				<a id="excelUp"><spring:message code='sys.btn.excel.up' /></a>
			</p></li>
		<li><p class="btn_grid">
				<a id="excelDown"><spring:message code='sys.btn.excel.dw' /></a>
	</ul>
	<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
        <div id="grid_wrap"></div>
</article>

 <ul class="center_btns mt20">
    <li><p class="btn_blue2 big"><a id="save">Save</a></p></li>
</ul> 

</section><!-- search_result end -->
<form id='popupForm'>
    <input type="hidden" id="invntryNo" name="invntryNo">
    <input type="hidden" id="autoFlag" name="autoFlag">
    <input type="hidden" id="eventType" name="eventType">
    <input type="hidden" id="itmType" name="itmType">
    <input type="hidden" id="ctgryType" name="ctgryType">
</form>
<form id="listForm" name="listForm" method="POST">
<input type="hidden" id="retnVal"    name="retnVal"    value="R"/>
</form>
</section>
   <div class="popup_wrap" id="giopenwindow" style="display:none"><!-- popup_wrap start -->
        <header class="pop_header"><!-- pop_header start -->
            <h1>Serial Check</h1>
            <ul class="right_opt">
                <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
            </ul>
        </header><!-- pop_header end -->
        
        <section class="pop_body"><!-- pop_body start -->
            <form id="giForm" name="giForm" method="POST">
            <input type="hidden" name="adjLocIdPop" id="adjLocIdPop"/>
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
                    <th scope="row">Stock Audit Number</th>
                    <td><input id="adjnoPop" name="adjnoPop" type="text" title=""  class="w100p" readonly="readonly" /></td>
                    <th scope="row">Stock Audit Item</th>
                    <td><input id="adjItemPop" name="adjItemPop" type="text" title=""  class="w100p" readonly="readonly" /></td>
                </tr>
                <tr>
                    <th scope="row">Material Code</th>
                    <td><input id="mtrCdPop" name="mtrCdPop" type="text" title=""  class="w100p" readonly="readonly" /></td>
                    <th scope="row">Location</th>
                    <td><input id="locPop" name="locPop" type="text" title=""  class="w100p" readonly="readonly" /></td>
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
                <li><p class="btn_blue2 big"><a id="savePop">Save</a></p></li>
            </ul>
            </form>
        
        </section>
    </div>
    
    
<div id="popup_wrap_excel_up" class="size_big popup_wrap" style="display:none"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1 id="popup_title">Stock Audit Excel Upload</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->
<ul class="right_btns">
    <!-- <li><p class="btn_blue"><a id="add">Add</a></p></li> -->
    
    <li><p class="btn_blue"><div class="auto_file"><!-- auto_file start -->
                                    <input type="file" id="fileSelector" title="file add" accept=".xlsx"/>
                                </div>
    </p></li>
</ul>
<article class="grid_wrap"><!-- grid_wrap start -->
       <div id="popup_wrap_excel"></div>
</article><!-- grid_wrap end -->
            <ul class="center_btns">
                <li><p class="btn_blue2 big"><a id="saveExcel">SAVE</a></p></li>
                <li><p class="btn_blue2 big"><a id="cancel">CANCEL</a></p></li>
            </ul>
</section><!-- pop_body end -->
<form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
</form>
</div><!-- popup_wrap end -->