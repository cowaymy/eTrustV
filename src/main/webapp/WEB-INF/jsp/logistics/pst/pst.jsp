<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<style type="text/css">
    .my-row-style {
	    background:#9FC93C;
	    font-weight:bold;
	    color:#22741C;
	}

</style>
<script type="text/javaScript" language="javascript">
var date = new Date().getDate();
var optionUnit = {
isShowChoose: false,
type : 'M'
};

var pststatuslist = [{"codeId":"1","codeName":"Active"},{"codeId":"4","codeName":"Completed"},{"codeId":"10","codeName":"Cancel"}];

    //AUIGrid 생성 후 반환 ID
    var listGrid;
    var serialGrid;
    var serialchk = false;
    var mdcGrid;
    var gridValue;

    var decedata = [{"code":"H","codeName":"Credit"},{"code":"S","codeName":"Debit"}];

    $(document).ready(function(){

        // AUIGrid 그리드를 생성합니다.
        createAUIGrid();

        AUIGrid.setSelectionMode(listGrid, "singleRow");

        // 셀 더블클릭 이벤트 바인딩

        //$('#pstStusId').multipleSelect("checkAll");
        doGetCombo('/common/selectCodeList.do', '357', '','cmbDealerType', 'S' , '');     // Dealer Type Combo Box
        doDefCombo(pststatuslist, '' ,'pstStusIds', 'M', 'f_multiCombo');


        AUIGrid.bind(listGrid, "cellEditBegin", function (event){
            if (event.item.balqty < 1){
                return false;
            }
            var checklist = AUIGrid.getCheckedRowItemsAll(listGrid);
            for(var i = 0 ; i < checklist.length ; i++){
                 if (checklist[i].psono != event.item.psono){
                    Common.alert("PST Salse Order No is different.");
                    return false;
                }
            }
        });

        AUIGrid.bind(listGrid, "cellEditEnd", function (event){

        	if (event.item.balqty < event.value){
        		Common.alert('The quantity you entered is too large.');
        		AUIGrid.setCellValue(listGrid, event.rowIndex, event.columnIndex, 0);
        	}else{
        		AUIGrid.addCheckedRowsByIds(listGrid, event.item.rnum);
        	}
        	if(event.value == ''){
        		AUIGrid.setCellValue(listGrid, event.rowIndex, event.columnIndex, 0);
        	}
        });

        AUIGrid.bind(listGrid, "cellDoubleClick", function(event){
            console.log(event);
            if (event.dataField == "psono"){
            	var param = "psono="+AUIGrid.getCellValue(listGrid, event.rowIndex, "psono");
            	Common.ajax("GET", "/logistics/pst/PstMaterialDocView.do", param , function(result) {

                    AUIGrid.setGridData(mdcGrid, result.data);
                    $("#mdc_grid").show();
                });
            }
            /*$("#rStcode").val(AUIGrid.getCellValue(listGrid, event.rowIndex, "reqstno"));
            document.searchForm.action = '/logistics/pos/PosView.do';
            document.searchForm.submit();*/
        });

        AUIGrid.bind(serialGrid, "cellEditBegin", function(event) {

            if (event.item.scanno != ""){
                return false;
            }else{
            	return true;
            }
           // AUIGrid.setSelectionByIndex(serialGrid, AUIGrid.getRowCount(serialGrid) - 1, 2);
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

    });

    // 조회조건 combo box
    function f_multiCombo(){
        $(function() {
            $('#pstStusIds').change(function() {

            }).multipleSelect({
               selectAll: true, // 전체선택
                width: '80%'
            });
            $('#pstStusIds').multipleSelect("checkAll");
        });
    }

    function createAUIGrid() {
        // AUIGrid 칼럼 설정

        // 데이터 형태는 다음과 같은 형태임,
        //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
        var columnLayout =[ { dataField : "rnum"      , headerText : "<spring:message code='log.head.psono'/>"                     , width : 140, editable : false, visible: false },
                            { dataField : "psoid"     , headerText : "<spring:message code='log.head.psono'/>"                     , width : 140, editable : false, visible: false },
                            { dataField : "psono"     , headerText : "<spring:message code='log.head.psono'/>"                     , width : 140, editable : false, visible: true  },
                            { dataField : "pstno"     , headerText : "PST No", width : 140, editable : false, visible: true  },
                            { dataField : "dtype"     , headerText : "<spring:message code='sys.gstexportation.grid1.dealerid'/>"  , width : 140, editable : false, visible: false },
                            { dataField : "dealerid"  , headerText : "<spring:message code='sys.gstexportation.grid1.dealerid'/>"  , width : 140, editable : false, visible: false },
                            { dataField : "dealernm"  , headerText : "<spring:message code='sys.gstexportation.grid1.dealername'/>", width : 140, editable : false, visible: true  },
                            { dataField : "cntname"   , headerText : "<spring:message code='sys.gstexportation.grid1.dealername'/>", width : 140, editable : false, visible: false },
                            { dataField : "pststus"   , headerText : "<spring:message code='log.head.psostus'/>"                   , width : 140, editable : false, visible: false },
                            { dataField : "pststuscd" , headerText : "<spring:message code='log.head.psostus'/>"                   , width : 140, editable : false, visible: true  },
                            { dataField : "pststusnm" , headerText : "<spring:message code='log.head.psostus'/>"                   , width : 140, editable : false, visible: false },
                            { dataField : "pstlocid"  , headerText : "<spring:message code='log.head.location'/>"                  , width : 140, editable : false, visible: false },
                            { dataField : "locid"     , headerText : "<spring:message code='log.head.location'/>"                  , width : 140, editable : false, visible: false },
                            { dataField : "loccode"   , headerText : "<spring:message code='log.head.location'/>"                  , width : 140, editable : false, visible: false },
                            { dataField : "locnm"     , headerText : "<spring:message code='log.head.location'/>"                  , width : 140, editable : false, visible: true  },
                            { dataField : "itmid"     , headerText : "<spring:message code='log.head.materialcode'/>"              , width : 140, editable : false, visible: false },
                            { dataField : "itmcd"     , headerText : "<spring:message code='log.head.materialcode'/>"              , width : 140, editable : false, visible: true  },
                            { dataField : "itmnm"     , headerText : "<spring:message code='log.head.materialcodetext'/>"          , width : 140, editable : false, visible: true  },
                            { dataField : "itmprc"    , headerText : "<spring:message code='log.head.materialcodetext'/>"          , width : 140, editable : false, visible: false },
                            { dataField : "serialchk" , headerText : "<spring:message code='log.head.materialcodetext'/>"          , width : 140, editable : false, visible: false },
                            { dataField : "qty"       , headerText : "<spring:message code='sys.scm.otdview.QTY'/>"                , width : 140, editable : false, visible: true  },
                            { dataField : "doqty"     , headerText : "<spring:message code='log.head.deliveredqty'/>"              , width : 140, editable : false, visible: true  },
                            { dataField : "balqty"    , headerText : "<spring:message code='log.head.remainqty'/>"                 , width : 140, editable : false, visible: true  },
                            { dataField : "reqqty"    , headerText : "<spring:message code='log.head.reqqty'/>"                    , width : 140, editable : true , visible: true  },
                            { dataField : "uom"       , headerText : "<spring:message code='log.head.uom'/>"                       , width : 140, editable : false, visible: false },
                            { dataField : "uomcd"     , headerText : "<spring:message code='log.head.uom'/>"                       , width : 140, editable : false, visible: true  },
                            { dataField : "crtdt"     , headerText : "<spring:message code='log.head.pstdate'/>"                   , width : 140, editable : false, visible: true , dataType:"date" , formatString : "dd/mm/yyyy" },
                            { dataField : "crtdt1"    , headerText : "<spring:message code='log.head.pstdate'/>"                   , width : 140, editable : false, visible: false },
                            { dataField : "psttypeid" , headerText : "<spring:message code='log.head.psttype'/>"                   , width : 140, editable : false, visible: false },
                            { dataField : "psttype"   , headerText : "<spring:message code='log.head.psttype'/>"                   , width : 140, editable : false, visible: true  },
                            { dataField : "pstpo"     , headerText : "<spring:message code='log.head.pstpo'/>"                     , width : 140, editable : false, visible: true  },
                            { dataField : "nric"      , headerText : "<spring:message code='sales.NRIC'/>"                         , width : 140, editable : false, visible: false },
                            { dataField : "userid"    , headerText : "<spring:message code='sys.title.user.id'/>"                  , width : 140, editable : false, visible: true  },
                            { dataField : "pic"       , headerText : "<spring:message code='log.head.pic'/>"                       , width : 140, editable : false, visible: false },
                            { dataField : "pcr"       , headerText : "<spring:message code='log.head.pic'/>"                       , width : 140, editable : false, visible: false },
                            { dataField : "pcti"      , headerText : "<spring:message code='log.head.pic'/>"                       , width : 140, editable : false, visible: false },
                            { dataField : "pctcd"     , headerText : "<spring:message code='log.head.pic'/>"                       , width : 140, editable : false, visible: false }
                          ];
        var serialcolumn =[ {dataField:"itmcd"        , headerText : "<spring:message code='log.head.materialcode'/>" ,width:"20%" ,height:30 },
                            {dataField:"itmname"      , headerText : "<spring:message code='log.head.materialname'/>" ,width:"25%" ,height:30 },
                            {dataField:"serial"       , headerText : "<spring:message code='log.head.serial'/>"       ,width:"30%" ,height:30,editable:true },
                            {dataField:"cnt61"        , headerText : "<spring:message code='log.head.serial'/>"       ,width:"30%" ,height:30,visible:false },
                            {dataField:"cnt62"        , headerText : "<spring:message code='log.head.serial'/>"       ,width:"30%" ,height:30,visible:false },
                            {dataField:"cnt63"        , headerText : "<spring:message code='log.head.serial'/>"       ,width:"30%" ,height:30,visible:false },
                            {dataField:"statustype"   , headerText : "<spring:message code='log.head.status'/>"       ,width:"30%" ,height:30,visible:false },
                            {dataField:"scanno"       , headerText : "<spring:message code='log.head.serial'/>"       ,width:"30%" ,height:30,visible:false }
                           ];

        var mtrcolumnLayout = [
                               {dataField:  "matrlDocNo",headerText :"<spring:message code='log.head.matrl_doc_no'/>"    ,width:200    ,height:30},
                               {dataField: "matrlDocItm",headerText :"<spring:message code='log.head.matrldocitm'/>"    ,width:100    ,height:30},
                               {dataField: "invntryMovType",headerText :"<spring:message code='log.head.move_type'/>"   ,width:100    ,height:30},
                               {dataField: "movtype",headerText :"<spring:message code='log.head.move_text'/>"  ,width:120    ,height:30},
                               {dataField: "reqStorgNm",headerText :"<spring:message code='log.head.reqloc'/>"  ,width:150    ,height:30},
                               {dataField: "matrlNo",headerText :"<spring:message code='log.head.matrl_code'/>"     ,width:120    ,height:30},
                               {dataField: "stkDesc",headerText :"<spring:message code='log.head.matrlname'/>"  ,width:300    ,height:30},
                               {dataField: "debtCrditIndict",headerText :"<spring:message code='log.head.debit/credit'/>"   ,width:120    ,height:30
                             ,labelFunction : function(  rowIndex, columnIndex, value, headerText, item ) {

                                   var retStr = "";

                                   for(var i=0,len=decedata.length; i<len; i++) {

                                       if(decedata[i]["code"] == value) {
                                           retStr = decedata[i]["codeName"];
                                           break;
                                       }
                                   }
                                   return retStr == "" ? value : retStr;
                               },editRenderer :
                               {
                                  type : "ComboBoxRenderer",
                                  showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                                  list : decedata,
                                  keyField : "code",
                                  valueField : "code"
                               }

                           },
                           {dataField:    "autoCrtItm" ,headerText:    ""   ,width:100    ,height:30},
                           {dataField:    "qty",headerText :"<spring:message code='log.head.qty'/>"    ,width:120    ,height:30},
                           {dataField:    "trantype",headerText :"<spring:message code='log.head.tran_type'/>"     ,width:120    ,height:30},
                           {dataField:    "postingdate",headerText :"<spring:message code='log.head.postingdate'/>"    ,width:120    ,height:30},
                           {dataField:    "codeName",headerText :"<spring:message code='log.head.uom'/>"   ,width:120    ,height:30}
              ];

        // 그리드 속성 설정
        var gridPros = {rowIdField : "rnum",usePaging : true,pageRowCount : 20,editable : true,fixedColumnCount : 16,showStateColumn : false,
        		        selectionMode : "multipleCells",headerHeight : 30,useGroupingPanel : false,skipReadonlyColumns : true,wrapSelectionMove : true,
        		        showRowCheckColumn : true ,showBranchOnGrouping : false
        		        };

        var serialop = {editable : true};

        var options = {
                usePaging : false,
                editable : false,
                useGroupingPanel : false,
                showStateColumn : false
                };

        //listGrid = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
        listGrid = AUIGrid.create("#list_grid_wrap", columnLayout, gridPros);

        serialGrid = AUIGrid.create("#serial_grid_wrap", serialcolumn, serialop);

        mdcGrid  = GridCommon.createAUIGrid("#mdc_grid", mtrcolumnLayout ,"", options);

        $("#mdc_grid").hide();
    }

    // 리스트 조회.
    function SearchListAjax(){
    	Common.ajax("GET", "/logistics/pst/PstSearchList.do", $("#searchForm").serialize(), function(result) {

            AUIGrid.setGridData(listGrid, result.data);
        });
    }

    // 리스트 조회.
    function fn_selectPstRequestDOListAjax() {
        Common.ajax("GET", "/sales/pst/selectPstRequestDOJsonList", $("#searchForm").serialize(), function(result) {
            AUIGrid.setGridData(listGrid, result);
        }
        );
    }

//     $.fn.clearForm = function() {
//         return this.each(function() {
//             var type = this.type, tag = this.tagName.toLowerCase();
//             if (tag === 'form'){
//                 return $(':input',this).clearForm();
//             }
//             if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
//                 this.value = '';
//             }else if (type === 'checkbox' || type === 'radio'){
//                 this.checked = false;
//             }else if (tag === 'select'){
//                 this.selectedIndex = -1;
//             }
//         });
//     };

    function fn_dealerToPst(){

        if(searchForm.cmbDealerType.value == 0){
            return false;
        }

//      doGetCombo('/common/selectCodeList.do', '358', $("#cmbDealerType").val(),'cmbPstType', 'M' , '');         // PST Type Combo Box
//      CommonCombo.make('cmbPstType', '/common/selectCodeList.do', {codeId : $("#cmbDealerType").val()} , '', {type: 'M'});
        CommonCombo.make("cmbPstType", "/sales/pst/pstTypeCmbJsonList", {groupCode : $("#cmbDealerType").val()} , '' , optionUnit); //Status
    }

    $(function(){
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
                    if(rowItem.item.reqqty==0){
                        str += "Please Check Delivery Qty of  " + rowItem.item.psono   + ", " + rowItem.item.itmname + "<br />";
                        checkDelqty= true;
                    }
                    /*if (rowItem.item.serialchk =='Y'){
                        serialchk = true;
                    }/*else{
                        serialchk = false;
                    }*/

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
                    if (serialchk){
                        //fn_itempopListSerial(checkedItems);
                        fn_itempopList_T(checkedItems);
                        $("#ascall").show();
                        $("#serial_grid_wrap_div").show();
                        AUIGrid.resize(serialGrid);
                    }else{
                        $("#serial_grid_wrap_div").hide();
                        $("#ascall").hide();
                    }

                }
            }

        });

    	$("#sampleclick").click(function(){
    		$.ajax({
    	        type : "GET",
    	        url : getContextPath() + "/logistics/pst/sampletest.do",
    	        dataType : "json",
    	        contentType : "application/json;charset=UTF-8",
    	        success : function(data) {

    	        },
    	        error: function(jqXHR, textStatus, errorThrown){

    	        },
    	        complete: function(){
    	        }
    	    });
    	});
    });





    function fn_itempopList_T(data){
        var itm_temp = "";
        var itm_qty  = 0;
        var itmdata = [];

        for (var i = 0 ; i < data.length ; i++){
            if (data[i].item.serialchk == 'Y'){
            	console.log(" 11 " + data[i].item.reqqty);
	            itm_qty = itm_qty + Number(data[i].item.reqqty);
            }
        }
        console.log(itm_qty)
        $("#serialqty").val(itm_qty);

        f_addrow();
    }

    function f_addrow(){
        var rowPos = "last";
        var item = new Object();
        item = {"itmcd":"","itmname":"","serial":"","cnt61":"","cnt62":"","cnt63":"","statustype":"","scanno":""};
        AUIGrid.addRow(serialGrid, item, rowPos);
        return false;
    }

    function giFunc(){
        var data = {};
        var checkdata = AUIGrid.getCheckedRowItemsAll(listGrid);
        var check     = AUIGrid.getCheckedRowItems(listGrid);
        //var serials   = AUIGrid.getAddedRowItems(serialGrid);
        var serials   = AUIGrid.getGridData(serialGrid);

        if (serialchk){
        //             if ($("#ascyn").val() == "Y"){
        //                 console.log('111');
        //             }else{
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
        //             }
            if ($("#serialqty").val() != AUIGrid.getRowCount(serialGrid)){
                Common.alert("Please check the serial.")
                return false;
            }
        }
        data.check   = check;
        data.checked = check;
        data.add     = serials;
        data.form    = $("#giForm").serializeJSON();

        console.log(data);

        Common.ajax("POST", "/logistics/pst/pstMovementReqDelivery.do", data, function(result) {
        	console.log(result);
            //var msg = result.message + "<br>MDN NO : "+result.data[1];
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

        serialchk = false;
    }

    function fn_serialChck(rowindex , rowitem , str){
        var schk = true;
        var ichk = true;
        var slocid = '';//session.locid;
        var checkdata = AUIGrid.getCheckedRowItemsAll(listGrid);

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

                 if (result.data[0].L61CNT > 0 || result.data[0].L62CNT == 0){//} || result.data[0].L63CNT > 0){
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

    function fn_pstreportGenerate(){
    	 var reportDownFileName = ""; //download report name
         var reportFileName = ""; //reportFileName
         var reportViewType = ""; //viewType
         $("#reportForm").append('<input type="hidden" id="reportFileName" name="reportFileName"  /> ');//report file name
         $("#reportForm").append('<input type="hidden" id="reportDownFileName" name="reportDownFileName" /> '); // download report name
         $("#reportForm").append('<input type="hidden" id="viewType" name="viewType" /> '); // download report  type
         var option = {
                 isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
               };
        var checkedItems = AUIGrid.getCheckedRowItemsAll(listGrid);
        for(var i=0, len = checkedItems.length; i<len; i++) {
            rowItem = checkedItems[i];

        if(checkedItems.length <= 0) {
            Common.alert('No data selected.');
            return false;
        }
        else{
            var checkedItems = AUIGrid.getCheckedRowItems(listGrid);
            var rowItem;
            rowItem = checkedItems[0];
            var pstno = rowItem.item.pstno;
         console.log("pstno : " + pstno);
         reportFileName = "/logistics/DO_PST_PDF.rpt"; //reportFileName
         $("#reportForm").append('<input type="hidden" id="V_DONO" name="V_DONO" value="" /> ');
         reportDownFileName = pstno +"_" +date+(new Date().getMonth()+1)+new Date().getFullYear(); //report name
         reportViewType = "PDF"; //viewType

         $("#V_DONO").val(pstno);

         $("#reportForm #reportFileName").val(reportFileName);
         $("#reportForm #reportDownFileName").val(reportDownFileName);
         $("#reportForm #viewType").val(reportViewType);

         //  report 호출

         Common.report("reportForm", option);

         }
        }

    }

</script>
<form name="reportForm" id="reportForm"></form>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>PST</li>
    <li id="sampleclick">PST list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>PST Request Do List</h2>
<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:SearchListAjax()"><span class="search"></span>Search</a></p></li>
</c:if>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="popForm" name="popForm" method="post">
    <input type="hidden" name="dealerId"  id="_dealerId"/>  <!-- Cust Id  -->
    <input type="hidden" name="dealerAddId"   id="_dealerAddId"/><!-- Address Id  -->
    <input type="hidden" name="dealerCntId"   id="_dealerCntId"> <!--Contact Id  -->
</form>
<form id="searchForm" name="searchForm" action="#" method="get">
    <input type="hidden" id="pstSalesOrdIdParam" name="pstSalesOrdIdParam" >
    <input type="hidden" id="pstDealerDelvryCntId" name="pstDealerDelvryCntId" >
    <input type="hidden" id="pstDealerMailCntId" name="pstDealerMailCntId" >
    <input type="hidden" id="pstDealerDelvryAddId" name="pstDealerDelvryAddId" >
    <input type="hidden" id="pstDealerMailAddId" name="pstDealerMailAddId" >
    <input type="hidden" id="pstStusIdParam" name="pstStusIdParam" >
    <input type="hidden" id="dealerTypeFlag" name="dealerTypeFlag" >
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
    <th scope="row">PST No</th>
    <td><input type="text" title="" id=pstRefNo name="pstRefNo" placeholder="PST Number" class="w100p" /></td>
    <th scope="row">PST Status</th>
    <td>
        <select class="multy_select w100p" id="pstStusIds" name="pstStusIds" multiple="multiple"></select>
    </td>
    <th scope="row">Create Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" id="createStDate" name="createStDate" title="Create start Date" value="${toDay}" placeholder="DD/MM/YYYY" class="j_date" /></p>
    <span>To</span>
    <p><input type="text" id="createEnDate" name="createEnDate" title="Create end Date" value="${toDay}" placeholder="DD/MM/YYYY" class="j_date" /></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row">Dealer ID</th>
    <td><input type="text" title="" id="pstDealerId" name="pstDealerId" placeholder="Dealer ID (Number Only)" class="w100p" /></td>
    <th scope="row">Dealer Name</th>
    <td><input type="text" title="" id="dealerName" name="dealerName" placeholder="Dealer Name" class="w100p" /></td>
    <th scope="row">NRIC/Company No</th>
    <td><input type="text" title="" id="pstNric" name="pstNric" placeholder="NRIC/Company Number" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Dealer Type</th>
    <td>
        <select class="select w100p" id="cmbDealerType" name="cmbDealerType" onchange="fn_dealerToPst()"></select>
    </td>
    <th scope="row">PST Type</th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="cmbPstType" name="cmbPstType" ></select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Customer PO</th>
    <td><input type="text" title="" id="pstCustPo" name="pstCustPo" placeholder="PO Number" class="w100p" /></td>
    <th scope="row">Person In Charge</th>
    <td><input type="text" title="" id="pInCharge" name="pInCharge" placeholder="Person In Charge" class="w100p" /></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->
</form>


</section><!-- search_table end -->

<section class="search_result"><!-- search_result start

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>
-->
<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
    <li><p class="btn_grid"><a id="download"><spring:message code='sys.btn.excel.dw' /></a></p></li>
</c:if>
    <li><p class="btn_grid"><a id="delivery">DELIVERY</a></p></li>
     <li><p class="btn_grid"><a onclick="javascript:fn_pstreportGenerate();">PST DO REPORT</a></p></li>
</ul>
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="list_grid_wrap" style="width:100%; height:350px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

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
         <input type="hidden" name="gtype"     id="gtype" value="GI"/>
         <input type="hidden" name="serialqty" id="serialqty"/>
         <input type="hidden" name="reqstno"   id="reqstno"/>
         <input type="hidden" name="prgnm"     id="prgnm" value="${param.CURRENT_MENU_CODE}"/>
         <input type="hidden" name="ascyn"     id="ascyn" value=""/>
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
<!--                  <td><p class="btn_blue"><a id="ascall"><span class="search"></span>Auto Serial Call</a></p></td> -->
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
         <article class="grid_wrap"  id="serial_grid_wrap_div"><!-- grid_wrap start -->
         <div id="serial_grid_wrap" class="mt10" style="width:100%;"></div>
         </article><!-- grid_wrap end -->
         <ul class="center_btns">
         <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
             <li><p class="btn_blue2 big"><a onclick="javascript:giFunc();">SAVE</a></p></li>
         </c:if>
         </ul>
         </form>

     </section>
 </div>
 <section class="tap_wrap"><!-- tap_wrap start -->
        <ul class="tap_type1">
            <li><a href="#" class="on">Compliance Remark</a></li>
        </ul>

        <article class="tap_area"><!-- tap_area start -->

            <article class="grid_wrap"><!-- grid_wrap start -->
                  <div id="mdc_grid" class="mt10" style="height:150px"></div>
            </article><!-- grid_wrap end -->

        </article><!-- tap_area end -->


    </section>
</section><!-- content end -->