<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/homecare-js-1.0.js"></script>

<style type="text/css">

    /* 커스텀 스타일 정의 */
    /*
    .auto_file2 {
        width:100%!important;
    }
    .auto_file2 > label {
        width:100%!important;
    }
   .auto_file2 label input[type=text]{width:40%!important; float:left}
   */

   /* 커스텀 칼럼 스타일 정의 */
   .my-column {
	    text-align: center;
	    margin-top: -20px;
	}

    .aui-grid-button-renderer {
        color: rgb(0, 0, 0);
        display: inline-block;
        line-height: 1em;
        -webkit-appearance: none;
        font-weight: bold;
        text-align: center;
        cursor: pointer;
        background: padding-box rgb(238, 238, 238);
        border-width: 1px;
        border-style: solid;
        border-color: rgb(170, 170, 170);
        border-image: initial;
        border-radius: 0px;
        padding: 2px !important;
        width : 80% !important;
    }

   .my-row-style { background:#FF5733; font-weight:bold; color:#22741C; }

</style>
<script type="text/javaScript">

var uomDs = [];
var uomObj = {};
<c:forEach var="obj" items="${uomList}">
  uomDs.push({codeId:"${obj.codeId}", codeName:"${obj.codeName}", code:"${obj.code}"});
  uomObj["${obj.codeId}"] = "${obj.codeName}";
</c:forEach>

//*****************************************/
var msIe = (js.browser.isMsie() || js.browser.isSafari());
console.log("msIe : " +msIe);
if(!msIe){
	var a=new AudioContext();
	//var a = new (window.AudioContext || window.webkitAudioContext)();
	function beep(vol, freq, duration){
	  v=a.createOscillator()
	  u=a.createGain()
	  v.connect(u)
	  v.frequency.value=freq
	  v.type="square"
	  u.connect(a.destination)
	  u.gain.value=vol*0.01
	  v.start(a.currentTime)
	  v.stop(a.currentTime+duration*0.001)
	}
	//*****************************************/
}

var scanGridId;

var scanLayout = [
		  {
		      dataField : "_del", // 임의의 고유값
		      headerText : " ",
		      style : "my-column",
		      width: 30,
		      editable : false,
		      renderer : {
		          type : "ButtonRenderer",
		          labelText : "X",
		          onclick : function(rowIndex, columnIndex, value, item) {
		        	  if(item.status == 0){
		                  AUIGrid.removeRow(scanGridId, rowIndex);
		        	  }else{

		                  $.extend(item, {
		                	  /* "allYn":"N"
		                	            , "rstNo":$("#sRstNo").val()
		                	            , "dryNo":$("#sDryNo").val()
				                        , "fromLocCode":$("#fromLocCode").val()
				                        , "toLocCode":$("#toLocCode").val()
				                        , "ioType":$("#ioType").val()
				                        , "transactionType":$("#transaction").val() */
				                        "allYn":"N",
				                        "scanNo":$("#scanNo").val()
				                        }
		                  );

		        		  Common.ajax("POST", "/logistics/serialMgmtNew/deleteSerial.do"
		                          , item
		                          , function(result){
		                              AUIGrid.removeRow(scanGridId, rowIndex);
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
		          }
		      }
		  }
        , {dataField:"boxno", headerText :"Serial No.", width:180}
        , {dataField:"status", visible:false}
        , {dataField:"stockId", visible:false}
        , {dataField:"stockCode", headerText:"Item Code", width:120}
        , {dataField:"stockName", headerText:"Item Description", width:280, style:"aui-grid-user-custom-left"}
        , { dataField:"uom", headerText:"Unit", width:120
           /*  , labelFunction:function(rowIndex, columnIndex, value, headerText, item ) {
                return uomObj[value]==null?"":js.String.strNvl(uomObj[value]);
            } */
        }
        , {dataField:"boxQty", headerText :"Box Qty", width:100}
        , {dataField:"eaQty", headerText :"EA Qty", width:100}
        , {dataField:"totQty", headerText :"Total Qty", width:100}
];

var serialGridPros = {
        editable : false,
        selectionMode : "singleCell",
        showRowNumColumn : false,
        showRowCheckColumn : false,
        showRowAllCheckBox : false,
        showStateColumn : false,
        showBranchOnGrouping : false,
        enableRestore: true,
        softRemovePolicy : "exceptNew" //사용자추가한 행은 바로 삭제
};

$(document).ready(function(){

    // Moblie Popup Setting
    //Common.setMobilePopup(true, false, 'serialGrid');

    scanGridId = GridCommon.createAUIGrid("serialGrid", scanLayout, null, serialGridPros);

    AUIGrid.setProp(scanGridId, "rowStyleFunction", function(rowIndex, item) {
        if(item.status == "0")
        {
            return "my-row-style";
        }
        return "";
    });

    doSysdate(0, 'pReturnDate');
    $("#pBranch").val("${param.branch}");
    $("#pBranchName").val("${param.branchName}");
    $("#pCodyId").val("${param.codyId}");
    $("#pCodyMem").val("${param.codyMem}");

    // 변수설정.
    /* if(Common.checkPlatformType() == "mobile") {
    	$("#sRstNo").val("${url.zRstNo}");            // requst no
    	$("#sStockAuditNo").val("${url.zRstNo}");            // requst no
        $("#sDryNo").val("${url.zDelvryNo}");         // delivery no
    	$("#transaction").val("${url.zTrnscType}");   // US : STO, UM : SMO, AD : STOCK AUDIT
    	$("#fromLocCode").val("${url.zFromLoc}");
    	$("#toLocCode").val("${url.zToLoc}");
    	$("#ioType").val("${url.zIoType}");
    }else{
    	$("#sRstNo").val($("#zRstNo").val());
    	$("#sStockAuditNo").val($("#zRstNo").val());
        $("#sDryNo").val($("#zDelvryNo").val());
    	$("#transaction").val($("#zTrnscType").val());
    	$("#fromLocCode").val($("#zFromLoc").val());
        $("#toLocCode").val($("#zToLoc").val());
        $("#ioType").val($("#zIoType").val());
    } */

    /* if(($("#transaction").val() == "UM" && $("#ioType").val() == "O") || $("#transaction").val() == "OG" || $("#transaction").val() == "OI" || $("#transaction").val() == "PS"){
    	$("#typeUM").show();
    	$("#typeUS").hide();
    	$("#typeAD").hide();
    }else if($("#transaction").val() == "AD"){
        $("#typeUM").hide();
        $("#typeUS").hide();
        $("#typeAD").show();
    }else{
    	$("#typeUM").hide();
    	$("#typeUS").show();
    	$("#typeAD").hide();
    } */

    /* $("#btnScanAllDel").click(function(){
    	Common
	        .confirm("Do you want to Delete All?",
	            function(){
	                var itemDs = {
                            "allYn":"Y",
                            "scanNo":$("#scanNo").val()
                            };


	                    Common.ajax("POST", "/logistics/returnusedparts/deleteSerial.do"
	                            , itemDs
	                            , function(result){
	                                AUIGrid.setGridData(scanGridId, []);
	                                $("#sTotal").html(0);
                                    $("#fTotal").html(0);
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
    }); */


    /* $("#btnScanDeleteGrid").click(function(){
    	var items = AUIGrid.getGridData(scanGridId);

        Common
	        .confirm("Do you want to All Delete?",
	            function(){

	        	    var itemDs = [];
	        	    $.each(items, function(i, row){
	                       if(row.status != 0){
	                           $.extend(row, {"allYn":"N"
	                        	   , "rstNo":$("#sRstNo").val()
	                               , "dryNo":$("#sDryNo").val()
	                               , "fromLocCode":$("#fromLocCode").val()
	                               , "toLocCode":$("#toLocCode").val()
	                               , "ioType":$("#ioType").val()
	                               , "transactionType":$("#transaction").val()}
	                           );
	                           itemDs.push(row);
	                       }
	                    });


	        	    if(itemDs.length > 0){
	                    Common.ajax("POST", "/logistics/returnUsedParts/deleteGridSerial.do"
	                            , {"dataList":itemDs}
	                            , function(result){
	                                AUIGrid.setGridData(scanGridId, []);
	                                $("#sTotal").html(0);
	                                $("#fTotal").html(0);
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
	        	    }else{
	        	    	AUIGrid.setGridData(scanGridId, []);
	        	    	$("#sTotal").html(0);
                        $("#fTotal").html(0);
	        	    }
	            }
        );


    }); */

    $("#btnScanClose").click(function(){
    	fn_scanClosePop();
    });

    $("#txtBarcode").change(function() {
        event.preventDefault();
        fn_splitBarcode();
    });

    $("#txtBarcode").focus();
});

function fn_splitBarcode(){
    if($("#txtBarcode").val() != null || js.String.strNvl($("#txtBarcode").val()) != ""){
        var BarCodeArray = $("#txtBarcode").val().toUpperCase().match(/.{1,18}/g);

        var unitType = "EA";
        var failSound = false;
        var rowData = {};
        var barInfo = [];
        var boxInfo = [];
        var stockCode = "";
        var ExistingBarCodeArray = AUIGrid.getColumnValues(scanGridId, "boxno");

        console.log("BarCodeArray " + BarCodeArray);
        console.log("BarCodeArray.length " + BarCodeArray.length);
        for (var i = 0 ; i < BarCodeArray.length ; i++){

            	//if(ExistingBarCodeArray.includes(BarCodeArray[i])){
                if(jQuery.inArray(BarCodeArray[i], ExistingBarCodeArray) >= 0){
                    //BarCodeArray[i] = BarCodeArray[i];
                    failSound = true;
                    rowData = {
                               "boxno":BarCodeArray[i]
                             , "status":0
                             , "stockName":"Serial No. (Duplicate)",
                            };
                    AUIGrid.addRow(scanGridId, rowData, "first");
                    continue;
                }

                if( BarCodeArray[i].length < 18 ){
                    failSound = true;
                    rowData = {
                                "boxno":BarCodeArray[i]
                              , "status":0
                              , "stockName":"Serial No. Does Not Exist.",
                            };
                    AUIGrid.addRow(scanGridId, rowData, "first");
                    continue;
                }

                stockCode = (js.String.roughScale(BarCodeArray[i].substr(3,5), 36)).toString();

                if(stockCode == "0"){
                    failSound = true;
                    rowData = {
                            "boxno":BarCodeArray[i]
                          , "status":0
                          , "stockName":"Serial No. Does Not Exist.",
                        };
                    AUIGrid.addRow(scanGridId, rowData, "first");
                    continue;
                }

                 barInfo.push({
                	 /* "barcode":BarCodeArray[i]
                               , "stockCode":stockCode
                               , "crDate":BarCodeArray[i].substr(8,5)
                               , "rstNo":$("#sRstNo").val()
                               , "dryNo":$("#sDryNo").val()
                               , "fromLocCode":$("#fromLocCode").val()
                               , "toLocCode":$("#toLocCode").val()
                               , "ioType":$("#ioType").val()
                               , "transactionType":$("#transaction").val()
                               , "scanNo":$("#scanNo").val()
                               , "unit":unitType */

                               "barcode":BarCodeArray[i]
                               ,"scanNo":$("#scanNo").val()
                               ,"codyId":$("#pCodyId").val()
                               ,"servicesdt":$("#servicesdt").val()
                               ,"serviceedt":$("#serviceedt").val()
                             });
            //}
        }
        console.log("barInfo.length" + barInfo.length);
        console.log("scanNo" + $("#scanNo").val());
        if(barInfo.length > 0){
            Common.ajax("POST", "/logistics/returnasusedparts/saveReturnBarcode.do"
                    , {"barList":barInfo}
                    , function(result){
                        $.each(result.dataList, function(idx, row){
                            if(row.status == 0){
                            	failSound = true;
                            }
                        	if(js.String.isNotEmpty(row.scanNo)){
                        		$("#scanNo").val(row.scanNo);
                        	}
                        	AUIGrid.addRow(scanGridId, row, "first");
                        });

                        if(!msIe){
	                        if(failSound){
	                        	beep(999, 210, 800); beep(999, 500, 800);
	                        	$("#txtBarcode").val("");
                                $("#txtBarcode").focus();
	                        }else{
	                            beep(100, 520, 200);
	                            $("#txtBarcode").val("");
                                $("#txtBarcode").focus();
	                        }
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
                        //Common.alert("Fail : " + jqXHR.responseJSON.message);
                    });
        }else{
        	// faile sound
        	if(!msIe){
        	    beep(999, 210, 800); beep(999, 500, 800);
        	    $("#txtBarcode").val("");
                $("#txtBarcode").focus();
        	}
        }

        //$("#txtBarcode").val("");
        //$("#txtBarcode").focus();
    }

}

//이벤트 정의
$(function(){

    // 행 추가 이벤트 바인딩
    AUIGrid.bind(scanGridId, "addRow", function(e){
        //console.log(e.type + " 이벤트 :  " + "삽입된 행 인덱스 : " + e.rowIndex + ", 삽입된 행 개수 : " + e.items.length);
        var success = js.String.deletecomma($("#sTotal").html());
        var fail = js.String.deletecomma($("#fTotal").html());

        var sCnt = 0
          , fCnt = 0;
        $.each(e.items, function(idx, row){
            if(row.status == 0){
                fCnt++;
            }else{
                sCnt++;
            }
        });

        $("#sTotal").html( js.String.addcomma(Number(success)+sCnt) );
        $("#fTotal").html( js.String.addcomma(Number(fail)+fCnt) );
    });


    // 행 삭제 이벤트 바인딩
    AUIGrid.bind(scanGridId, "removeRow", function(e){
        var success = js.String.deletecomma($("#sTotal").html());
        var fail = js.String.deletecomma($("#fTotal").html());

        var sCnt = 0
        , fCnt = 0;
        $.each(e.items, function(idx, row){
            if(row.status == 0){
                fCnt++;
            }else{
                sCnt++;
            }
        });

        $("#sTotal").html( js.String.addcomma(Number(success)-sCnt) );
        $("#fTotal").html( js.String.addcomma(Number(fail)-fCnt) );
    });


});


function fn_scanClosePop(){
	// Moblie Popup Setting
    /* if(Common.checkPlatformType() == "mobile") {
        opener.fn_PopSerialClose();
    } else { */
    	$("#btnPopSearch").click();
    	$('#_serialASScanPop').remove();
    //}
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Serial No. Scanning</h1>
<ul class="right_opt">
    <!-- <li><p class="btn_blue2"><a id="btnScanAllDel" href="#">Clear Serial</a></p></li> -->
    <!-- <li><p class="btn_blue2"><a id="btnScanDeleteGrid" >All Delete</a></p></li> -->
    <li><p class="btn_blue2"><a id="btnScanClose" >CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
	<aside class="title_line"><!-- title_line start -->
	<ul class="right_btns">
	</ul>
	</aside><!-- title_line end -->
	<table class="type1">
		<caption>table</caption>
		<colgroup>
		    <col style="width:150px" />
		    <col style="width:*" />
		</colgroup>
		<tbody>
			<tr>
			    <th scope="row">Branch</th>
			    <td colspan="3" >
			        <input type="text" id="pBranchName" name="pBranchName" placeholder="" class="w100p readonly" style="min-width:150px" readonly value=""'/>
			    </td>
			</tr>
			<tr>
                <th scope="row">Cody Member</th>
                <td colspan="3" >
                    <input type="text" id="pCodyMem" name="pCodyMem" placeholder="" class="w100p readonly" style="min-width:150px" readonly value=""'/>
                </td>
            </tr>
            <tr>
                <th scope="row">Return Date</th>
                <td colspan="3" >
                    <input type="text" id="pReturnDate" name="pReturnDate" placeholder="" class="w100p readonly" style="min-width:150px" readonly value=""'/>
                </td>
            </tr>
			<!-- <tr id="typeAD" style="display:none;">
                <th scope="row">Stock Audit No.</th>
                <td colspan="3" >
                    <input type="text" id="sStockAuditNo" name="sStockAuditNo" placeholder="" class="w100p readonly" style="min-width:150px" readonly value=""'/>
                </td>
            </tr> -->
			<!-- <tr id="typeUM" style="display:none;">
                <th scope="row">Request No.</th>
                <td colspan="3" >
                    <input type="text" id="sRstNo" name="sRstNo" placeholder="" class="w100p readonly" style="min-width:150px" readonly value=""'/>

                    <input type="hidden" id="transaction" />
                    <input type="hidden" id="toLocCode" />
                    <input type="hidden" id="fromLocCode" />
                    <input type="hidden" id="ioType" />

                    <input type="hidden" id="scanNo" />

                </td>
            </tr> -->
            <input type="hidden" name="pBranch" id="pBranch" value=""/>
        <input type="hidden" name="pCodyId" id="pCodyId" value=""/>
		</tbody>
	</table>


<!------------------------------------------------------------------------------
    Content START
------------------------------------------------------------------------------->

    <aside class="title_line"><!-- title_line start -->
       <h3>Serial Scan</h3>
	   <ul class="right_btns">
	       <li style="display:none;"><p class="btn_blue"><a id="btnScanImport" href="#">Import</a></p></li>
	   </ul>
    </aside><!-- title_line end -->


    <!-- <form id="barScanForm" name="barScanForm" method="POST"> -->

        <table class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:150px" />
            </colgroup>
            <tbody>
                <tr>
                    <th scope="row"><span style="color:red">*</span><b>BARCODE</b></th>
                    <td>
                         <!-- <input type="text"  id="txtBarcode" name="txtBarcode" onchange="javascript:fn_splitBarcode();" placeholder="Please select here before scanning." style="height:40px;width:80%; text-transform:uppercase;" /> -->
                        <input type="text"  id="txtBarcode" name="txtBarcode" placeholder="Please select here before scanning." style="height:40px;width:99%; text-transform:uppercase;" />
                    </td>
                </tr>
             </tbody>
        </table><!-- table end -->
    <!-- </form> -->

    <aside class="title_line">
       <h3>
            &nbsp; * success : <span id="sTotal" style="color:blue">0</span>, &nbsp; fail : <span id="fTotal" style="color:red">0</span>
       </h3>
    </aside>

    <section class="search_result">
        <article class="grid_wrap">
            <div id="serialGrid" class="autoGridHeight"></div>
        </article>
    </section>
    &nbsp;

    <ul class="center_btns"></ul>


<!------------------------------------------------------------------------------
     Content END
------------------------------------------------------------------------------->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
