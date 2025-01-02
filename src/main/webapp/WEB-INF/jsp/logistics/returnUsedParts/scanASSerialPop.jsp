<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<style type="text/css">


   /* 커스텀 칼럼 스타일 정의 */
   .my-column {
      text-align: center;
      margin-top: -20px;
  }

   .my-row-style { background:#FF5733; font-weight:bold; color:#22741C; text-decoration:underline;}
   .aui-grid-link-renderer1 {
      text-decoration:underline;
      color: #4374D9 !important;
      cursor: pointer;
      text-align: right;
    }
</style>
<script type="text/javaScript">

var popupObj;
var scanInfoGridId;
//var gradeList = new Array();

var scanInfoLayout = [
          /* {dataField:"delvryNo", visible:false}
        , {dataField:"delvryNoItm", visible:false}
        ,  */
        {dataField:"stkCode", headerText:"Item Code", width:100}
        , {dataField:"stkDesc", headerText:"Item Description", width:280, style:"aui-grid-user-custom-left"}
        /* , {dataField:"delGiCmplt", visible:false}
        , {dataField:"serialChk", headerText:"Serial", width:70} */
        , {dataField:"returnQty", headerText:"return QTY", width:160
            , style:"aui-grid-user-custom-right"
            , dataType:"numeric"
            , formatString:"#,##0"
        }
        , {dataField:"scanQty", headerText:"Scaned(Request) QTY", width:160
            , style:"aui-grid-user-custom-right"
            , dataType:"numeric"
            , formatString:"#,##0"
            , styleFunction : function(rowIndex, columnIndex, value, headerText, item, dataField){
                if(item.returnQty != value){
                    return "my-row-style";
                } else if(item.returnQty == value){
                    return "aui-grid-link-renderer1";
                }
            }
        }
       /* ,{dataField:"mtype", visible:false} */
       /* ,{dataField:"reqstNo", headerText:"SMO No.", width:140, editable : false} */
];

/* var gradeLayout = [
                      {dataField:"delvryNo", visible:false}
                    , {dataField:"delvryNoItm", visible:false}
                    , {dataField:"itmCode", headerText:"Item Code", width:120, editable:false}
                    , {dataField:"itmName", headerText:"Item Description", width:280, editable:false, style:"aui-grid-user-custom-left"}
                    , {dataField:"serialNo", headerText:"Serial No", width:160, editable:false}
                    , {dataField: "lastLocStkGrad",headerText :"<spring:message code='log.head.grade'/>", width:120, height:30
                        ,   labelFunction : function(rowIndex, columnIndex, value, headerText, item) {
                            var retStr = "";
                            for (var i = 0, len = gradeList.length; i < len; i++) {
                                if (gradeList[i]["code"] == value) {
                                    retStr = gradeList[i]["codeName"];
                                    break;
                                }
                            }
                            return retStr == "" ? value : retStr;
                        },
                        editRenderer : {
                             type : "DropDownListRenderer",
                             showEditorBtnOver : true, // 마우스 오버 시 에디터버턴 보이기
                             listFunction : function(rowIndex, columnIndex, item, dataField) {
                                 return gradeList ;
                             },
                             list : gradeList,
                             keyField : "code",
                             valueField : "codeName"
                                         }
                     }
            ]; */

var scanInfoPros = {
    usePaging : false,
        editable : false,
        selectionMode : "singleCell",
        showRowNumColumn : true,
        enableFilter : true,
        showRowCheckColumn : false,
        showRowAllCheckBox : false,
        showStateColumn : false,
        showBranchOnGrouping : false,
        enableRestore: true,
        softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
};

/* var gradInfoPros = {
        usePaging : false,
        editable : true,
        selectionMode : "singleCell",
        showRowNumColumn : true,
        enableFilter : true,
        showRowCheckColumn : false,
        showRowAllCheckBox : false,
        showStateColumn : false,
        showBranchOnGrouping : false,
        enableRestore: true,
        softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
}; */

$(document).ready(function(){

  //$("#gradeGrid").hide();

    // Moblie Popup Setting
    Common.setMobilePopup(true, false,'scanInfoGrid');

    doSysdate(0, 'returnDate');
    //doSysdate(0, 'zGrptdate');
    //doSysdate(0, 'zGrpfdate');

    scanInfoGridId = GridCommon.createAUIGrid("scanInfoGrid", scanInfoLayout, null, scanInfoPros);
    /* var ROLE_ID = "${SESSION_INFO.roleId}";
    var access_auth1 = "${PAGE_AUTH.funcUserDefine1}";
    var selectedBranch = "${url.branch}";
    if(ROLE_ID == "130 " || ROLE_ID == "137 " // Administrator
        || access_auth1 == 'Y'){
      doGetComboData('/logistics/returnusedparts/selectSelectedBranchCodeList.do',{userBranchId: selectedBranch}, '', 'searchBranch', 'S','');
    }else{
      doGetComboData('/logistics/returnusedparts/selectSelectedBranchCodeList.do',{userBranchId: '${SESSION_INFO.userBranchId}'}, '', 'searchBranch', 'S','');
    } */

    $("#zBranch").val("${param.branch}");
    $("#sBranchName").val("${param.branchName}");
    $("#zCodyId").val("${param.codyId}");
    $("#sCodyMem").val("${param.codyMem}");
    fn_serialScanInListAjax();
    //AUIGrid.setGridData(scanInfoGridId, data.list);

    //gradeGridId = GridCommon.createAUIGrid("gradeGrid", gradeLayout, null, gradInfoPros);

    /* if(Common.checkPlatformType() == "mobile") {
      $("#zDelyNo").val("${param.zDelvryNo}");
      $("#zDelvryNo").val("${param.zDelvryNo}");
        $("#zRstNo").val("${param.zReqstno}");
      $("#zFromLoc").val("${param.zRcvloc}");
      $("#zToLoc").val("${param.zReqloc}");

    }else{
      $("#zDelyNo").val($("#zDelvryNo").val());
      $("#zDelvryNo").val($("#zDelvryNo").val());
        $("#zRstNo").val($("#zReqstno").val());
        $("#zFromLoc").val($("#zRcvloc").val());
        $("#zToLoc").val($("#zReqloc").val());
    } */

    //fn_clearSerialFirst();


    $("#btnPopSearch").click(function(){
      fn_serialScanInListAjax();
    });

    $("#btnClose").click(function(){
      fn_ClosePop();
    });

    $("#btnPopIssueSave").click(function(){

      if(FormUtil.isEmpty($("#returnDate").val())) {
            Common.alert("Please select the Return Date.");
            return false;
        }
      /* if(FormUtil.isEmpty($("#zGrptdate").val())) {
            Common.alert("Please select the GR Posting Date.");
            return false;
        } */

        /* if(FormUtil.isEmpty($("#zGrpfdate").val())) {
            Common.alert("Please select the GR Doc Date.");
            return false;
        } */

      var check = GridCommon.getGridData(scanInfoGridId);
        var listLength = check.all.length;
        console.log("listLength" + listLength);
        if(listLength == 0 || $("#scanNo").val() == undefined  || $("#scanNo").val() == ""){
            Common.alert("No Record scanned.");
            return false;
        }
      //var addedItems = AUIGrid.getColumnValues(gradeGridId,"lastLocStkGrad");
        //var getRow = AUIGrid.getRowCount(gradeGridId);

        /* var gradchk = false;
        var delychek = check.all[0].delvryNo;

        for(var i = 0 ; i < check.all.length ; i++){
            var docno  = check.all[i].docno;
            if(docno !=null && docno != ""){
                docno = docno.substring(0, 3);
            }

            if(check.all[i].mtype =="UM93" && check.all[i].serialChk=="Y" && docno == "RET" ){
                gradchk = true;
            }

            if(delychek != check.all[i].delvryNo){
                Common.alert("Delivery No Is Different.");
                return false;
            }
       }

       var graddata;

       if(gradchk){
         if(addedItems.length < 1){
           Common.alert("Please select Grade.");
           return false;
       }else{
           for(var i =0; i < getRow ; i++){
               if(""==addedItems[i] || null==addedItems[i]){
                   Common.alert("Please select Grade.");
                   return false;
               }
           }
       }

       graddata = GridCommon.getEditData(gradeGridId);
     } */

       /* for(var i = 0 ; i < check.all.length ; i++){
         if (check.all[i].delydt == "" || check.all[i].delydt == null){
             Common.alert("Please check the Delivery Date.")
               return false;
           }
         if (check.all[i].gidt == "" || check.all[i].gidt == null){
               Common.alert("Please check the GR Date.")
              return false;
           }
         if (check.all[i].serialChk != "Y"){
               Common.alert("Please check Serial Chk YN.")
              return false;
           }
         if (check.all[i].serialChk == "Y" && check.all[i].scanQty == 0){
               Common.alert("Scaned(Request) Qty does not exist.")
              return false;
           }
         if (check.all[i].scanQty != check.all[i].reqQty){
               Common.alert("Scan(Request) Qty and GR qty must be the same..")
              return false;
           }
       } */

       var obj = $("#ScanSerialInForm").serializeJSON();
       obj.gridList = check;
       obj.scanNo = $("#scanNo").val();
       //obj.gradeList = graddata;

       if(Common.confirm("Do you want to save?", function(){

           Common.ajax("POST", "/logistics/returnasusedparts/saveReturnUsedSerial.do", obj, function(result) {
        	   Common.alert("Record(s) updated.");
        	   $("#btnClose").click();
           });
       }));
    });

    $("#btnAllDel").click(function(){
        /* if($(this).parent().hasClass("btn_disabled") == true){
            return false;
        } */

        /* var msg = "";
        if($("#zTrnscType").val() == "UM"){
            msg = "Do you want to All Delete Delivery No ["+$("#zDelvryNo").val()+"]?";
        }else{
            msg = "Do you want to All Delete Delivery No ["+$("#zDelvryNo").val()+"]?";
        } */

      var check = GridCommon.getGridData(scanInfoGridId);
        var listLength = check.all.length;
        if(listLength == 0 || $("#scanNo").val() == undefined  || $("#scanNo").val() == ""){
            Common.alert("No Record scanned.");
            return false;
        }

        Common
            .confirm("Do you want to Clear all serial?",
                function(){
                    var itemDs = {
                        /* "allYn":"Y"
                            , "rstNo":$("#zRstNo").val()
                            , "dryNo":$("#zDelvryNo").val()
                            , "fromLocCode":$("#zFromLoc").val()
                            , "toLocCode":$("#zToLoc").val()
                            , "ioType":$("#zIoType").val()
                            , "transactionType":$("#zTrnscType").val() */

                            "allYn":"Y",
                            "scanNo":$("#scanNo").val()
                            };


                        Common.ajax("POST", "/logistics/returnasusedparts/deleteSerial.do"
                                , itemDs
                                , function(result){
                                    $("#btnPopSearch").click();
                                    $("#scanNo").val("");
                                }
                                , function(jqXHR, textStatus, errorThrown){
                                    try{
                                        if (FormUtil.isNotEmpty(jqXHR.responseJSON)) {
                                            console.log("code : "  + jqXHR.responseJSON.code);
                                            Common.alert("Fail : " + jqXHR.responseJSON.message);
                                        }else{
                                            console.log("Fail Status : " + jqXHR.status);
                                            console.log("code : "        + jqXHR.responseJSON.code);
                                            console.log("message : "     + jqXHR.responseJSON.message);
                                            console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
                                        }
                                    }catch (e){
                                        console.log(e);
                                    }
                       });

                }
        );
    });

    $("#btnPopSerial").click(function(){
      if($(this).parent().hasClass("btn_disabled") == true){
            return false;
        }

      var param = {
              "branch" : $("#zBranch").val(),
              "branchName" : $("#sBranchName").val(),
              "codyId" : $("#zCodyId").val(),
              "codyMem" : $("#sCodyMem").val()
          };

      /* if(Common.checkPlatformType() == "mobile") {
            popupObj = Common.popupWin("ScanSerialInForm", "/logistics/returnUsedParts/serialScanCommonPop.do", {width : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
        } else{ */
            Common.popupDiv("/logistics/returnasusedparts/serialASScanCommonPop.do", param, null, true, '_serialASScanPop');
        //}
    });

    /* AUIGrid.bind(scanInfoGridId, "cellClick", function( event ) {
        var rowIndex = event.rowIndex;
        var dataField = AUIGrid.getDataFieldByColumnIndex(scanInfoGridId, event.columnIndex);
        var serialChk = AUIGrid.getCellValue(scanInfoGridId, rowIndex, "serialChk");
        var scanQty = AUIGrid.getCellValue(scanInfoGridId, rowIndex, "scanQty");

        if(dataField == "scanQty"){
            var rowIndex = event.rowIndex;
            if(serialChk == "Y" && scanQty > 0){
                $("#ScanSerialInForm #pDeliveryNo").val(AUIGrid.getCellValue(scanInfoGridId, rowIndex, "delvryNo"));
                $("#ScanSerialInForm #pDeliveryItem").val(AUIGrid.getCellValue(scanInfoGridId, rowIndex, "delvryNoItm"));
                $("#ScanSerialInForm #pStatus").val("I");

                fn_scanSearchPop();
            }
        }
    }); */
});

function fn_serialScanInListAjax() {

    /* var checkdata = AUIGrid.getCheckedRowItemsAll(listGrid);
    data.checked = checkdata; */
  var url = "/logistics/returnasusedparts/selectScanSerialInList.do";
    /* var arrDelyNo = ($("#zDelyNo").val()).split(',');

    if(arrDelyNo.length == 0){
        Common.alert("Please, check the mandatory value.");
        return false;
    } */

    var data = {
    		"codyMem" : $("#zCodyId").val()
    		,"scanNo" : $("#scanNo").val()
    };

    // 초기화
    $("#btnPopSerial").parent().addClass("btn_disabled");
    $("#btnAllDel").parent().addClass("btn_disabled");
    AUIGrid.setGridData(scanInfoGridId, []);

    Common.ajax("POST" , url , data , function(data){
        var mtype = '';
        var delvryNo = '';
        if(data.total > 0){
            /* if(data.dataList[0].serialRequireChkYn == "Y"){
                var isSerial = false;
                $.each(data.dataList, function(i, row){
                    if(row.serialChk == "Y"){
                        isSerial = true;
                    }
                    if(isSerial){
                        $("#btnPopSerial").parent().removeClass("btn_disabled");
                        $("#btnAllDel").parent().removeClass("btn_disabled");
                    }
                    mtype = row.mtype;
                    delvryNo = row.delvryNo;
                });
            } */
            $("#btnPopSerial").parent().removeClass("btn_disabled");
            $("#btnAllDel").parent().removeClass("btn_disabled");
            AUIGrid.setGridData(scanInfoGridId, data.dataList);
        }
    });

    $("#ingGrNo").val($("#zRstNo").val());
}

/* function fn_clearSerialFirst() {
    console.log('ingGrNo ' + $("#ingGrNo").val());
    console.log('ioType ' + $("#ioType").val());
    var ingGrNo = $("#zRstNo").val();
    var ioType =  $("#zIoType").val();
    Common.ajaxSync("POST", "/logistics/stocktransfer/clearSerialNo.do"
                    , {"grNo": ingGrNo, "ioType" : ioType}
                    , function(result){

                              }
                             , function(jqXHR, textStatus, errorThrown){
                                 try{
                                     console.log("Fail Status : " + jqXHR.status);
                                     console.log("code : "        + jqXHR.responseJSON.code);
                                     console.log("message : "     + jqXHR.responseJSON.message);
                                     console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
                                 }catch (e){
                                     console.log(e);
                                 }
                                 Common.alert("Fail : " + jqXHR.responseJSON.message);
                     });
} */

function fn_ClosePop(){
  /* var ingGrNo = $("#ingGrNo").val();
    var ioType =  $("#zIoType").val(); */
    /* console.log('ingGrNo ' + $("#ingGrNo").val());
    console.log('ioType ' + $("#zIoType").val());
      if(js.String.isEmpty($("#zRstNo").val())){
    // Moblie Popup Setting
      if(Common.checkPlatformType() == "mobile") {
          opener.fn_PopSmoIssueClose();
      } else {
        $('#_divSmoIssuePop').remove();
        SearchListAjax();
      }
    }else{ */
      $('#_divScanASSerialPop').remove();
    $("#search").click();
       /*  if(ingGrNo == ""){
            $('#_divSmoIssuePop').remove();
            $("#search").click();
        }else{
            Common.alert("Upon closing, all temporary scanned serial no. will be removed (If Any).");

            Common.ajax("POST", "/logistics/stocktransfer/clearSerialNo.do"
                    , {"reqstNo": ingGrNo, "ioType" : ioType}
                    , function(result){
                     //Common.alert(result.data  + "<spring:message code='sys.msg.savedCnt'/>");
                     // Moblie Popup Setting
                     if(Common.checkPlatformType() == "mobile") {
                         if( typeof(opener.fn_PopClose) != "undefined" ){
                             opener.fn_PopClose();
                         }else{
                             window.close();
                         }
                     } else {
                         //$("#btnSearch").click();
                         $('#_divSmoIssuePop').remove();
                     }
                              }
                             , function(jqXHR, textStatus, errorThrown){
                                 try{
                                     console.log("Fail Status : " + jqXHR.status);
                                     console.log("code : "        + jqXHR.responseJSON.code);
                                     console.log("message : "     + jqXHR.responseJSON.message);
                                     console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
                                 }catch (e){
                                     console.log(e);
                                 }
                                 Common.alert("Fail : " + jqXHR.responseJSON.message);
                     });
        } */
    //}
}

function fn_PopSerialClose(){
    if(popupObj!=null) popupObj.close();
    $("#btnPopSearch").click();
}

/* function fn_gradeSerial(str){

    var data = { delvryNo : str };

    Common.ajax("GET", "/logistics/stockMovement/selectSMOIssueInSerialGradeList.do",
            data,
            function(result) {
              AUIGrid.setGridData(gradeGridId, result);
                fn_gradComb();

    },  function(jqXHR, textStatus, errorThrown) {
        try {
        } catch (e) {
        }
        Common.alert("Fail : " + jqXHR.responseJSON.message);
    });
} */

/* function fn_gradComb(){
    var paramdata = { groupCode : '390' , orderValue : 'CODE_ID'};
    Common.ajaxSync("GET", "/common/selectCodeList.do", paramdata,
        function(result) {
            for (var i = 0; i < result.length; i++) {
                var list = new Object();
                list.code = result[i].code;
                list.codeId = result[i].codeId;
                list.codeName = result[i].codeName;
                list.description = result[i].description;
                gradeList.push(list);
            }
        });
} */

//Serial Search Pop
/* function fn_scanSearchPop(){
    if(Common.checkPlatformType() == "mobile") {
        popupObj = Common.popupWin("ScanSerialInForm", "/logistics/SerialMgmt/scanSearchPop.do", {width : "1000px", height : "1000px", height : "720", resizable: "no", scrollbars: "yes"});
    } else{
        Common.popupDiv("/logistics/SerialMgmt/scanSearchPop.do", $("#ScanSerialInForm").serializeJSON(), null, true, '_scanSearchPop');
    }
} */
</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Return receipt</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="btnPopIssueSave" >SAVE</a></p></li>
    <li><p class="btn_blue2"><a id="btnClose" >CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

    <form id="ScanSerialInForm" name="ScanSerialInForm" method="POST">
        <!-- <input type="hidden" name="zTrnscType" id="zTrnscType" value="UM" />
        <input type="hidden" name="zRstNo" id="zRstNo" value=""/>
        <input type="hidden" name="zDelvryNo" id="zDelvryNo" value=""/>
        <input type="hidden" name="zFromLoc" id="zFromLoc" />
        <input type="hidden" name="zToLoc" id="zToLoc" />
        <input type="hidden" name="zIoType" id="zIoType" value="I"/>
        <input type="hidden" name="ztype" id="ztype" value="GR"/>
      <input type="hidden" name="pDeliveryNo" id="pDeliveryNo"/>
      <input type="hidden" name="pDeliveryItem"  id="pDeliveryItem"/>
      <input type="hidden" name="pStatus" id="pStatus"/>
        <input type="hidden" name="ingGrNo" id="ingGrNo" /> -->

        <input type="hidden" name="zBranch" id="zBranch" value=""/>
        <input type="hidden" name="zCodyId" id="zCodyId" value=""/>

        <input type="hidden" id="scanNo" />

        <table class="type1">
          <caption>search table</caption>
          <colgroup>
              <col style="width:150px" />
              <col style="width:*" />
          </colgroup>
          <tbody>
                  <!-- <tr>
                     <th scope="row">Delivery No.</th>
                     <td ><input id="zDelyNo" name="zDelyNo" type="text" placeholder="" class="w100p readonly" readonly /></td>
                    </tr> -->
                    <tr>
                       <th scope="row">Branch</th>
                       <td ><input id="sBranchName" name="sBranchName" type="text" placeholder="" class="w100p readonly" readonly /></td>
                    </tr>
                    <tr>
                        <th scope="row">Cody Member<span class="must">*</span></th>
                        <td ><input id="sCodyMem" name="sCodyMem" type="text" class="w100p" readonly /></td>
                    </tr>
                    <tr>
                        <th scope="row">Return Date<span class="must">*</span></th>
                        <td ><input id="returnDate" name="returnDate" type="text" title="Return Date" placeholder="DD/MM/YYYY" class="j_date w100p" readonly /></td>
                    </tr>
                  <!-- <tr>
                      <th scope="row">GR Posting Date<span class="must">*</span></th>
                      <td ><input id="zGrptdate" name="zGrptdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" readonly /></td>
                  </tr> -->
                  <!-- <tr>
                      <th scope="row">GR Doc Date<span class="must">*</span></th>
                      <td ><input id="zGrpfdate" name="zGrpfdate" type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" readonly /></td>
                  </tr> -->
                  <!-- <tr>
                      <th scope="row">Header Text</th>
                      <td><input type="text" name="zDoctext" id="zDoctext" maxlength="50" class="w100p"/></td>
                  </tr> -->
          </tbody>
        </table>
    </form>

    <aside class="title_line">
       <h3>Serial Scan</h3>
     <ul class="right_btns">
            <li style="display:none;"><p class="btn_grid"><a id="btnPopSearch">Search</a></p></li>
            <li><p class="btn_grid"><a id="btnAllDel">Clear Serial</a></p></li>
            <li><p class="btn_grid"><a id="btnPopSerial">Serial Scan</a></p></li>
     </ul>
    </aside>

    <section class="search_result">
        <article class="grid_wrap">
            <div id="scanInfoGrid" style="height:250px;"></div>
            <!-- <div id="gradeGrid" style="height:150px;"></div> -->
        </article>
    </section>
    &nbsp;
</section>
</div>
