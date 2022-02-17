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

                          $.extend(item,
                          {
                          "transitNo":$("#sTransitNo").val()
                          , "serialNo":item.serialNo
                          }
                          );

                          Common.ajax("POST", "/services/hiCare/deleteHiCareDeliverySerial.do"
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
        , {dataField:"serialNo", headerText :"Serial No.", width:300}
        , {dataField:"model", visible:false}
        , {dataField:"desc", headerText :"Description", width:300}
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

    scanGridId = GridCommon.createAUIGrid("serialGrid", scanLayout, null, serialGridPros);

    AUIGrid.setProp(scanGridId, "rowStyleFunction", function(rowIndex, item) {

        if(item.status == "0")
        {
            return "my-row-style";
        }
        return "";
    });

    $("#sTransitNo").val("${url.transitNo}");

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
        var ExistingBarCodeArray = AUIGrid.getColumnValues(scanGridId, "serialNo");

        console.log("BarCodeArray " + BarCodeArray);
        console.log("BarCodeArray.length " + BarCodeArray.length);
        for (var i = 0 ; i < BarCodeArray.length ; i++){
            //if(ExistingBarCodeArray.includes(BarCodeArray[i])){
            console.log("BarCodeArray[i] " + BarCodeArray[i]);
            console.log("ExistingBarCodeArray " + ExistingBarCodeArray);
            console.log(jQuery.inArray(BarCodeArray[i], ExistingBarCodeArray) );
            if(jQuery.inArray(BarCodeArray[i], ExistingBarCodeArray) >= 0){
                //BarCodeArray[i] = BarCodeArray[i];
                failSound = true;
                rowData = {
                           "serialNo":BarCodeArray[i]
                         , "status":0
                         , "desc":"Serial No. (Duplicate)",
                        };
                AUIGrid.addRow(scanGridId, rowData, "first");
                continue;
            }

            if( BarCodeArray[i].length < 18 ){
                failSound = true;
                rowData = {
                            "serialNo":BarCodeArray[i]
                          , "status":0
                          , "desc":"Serial No. Does Not Exist.",
                        };
                AUIGrid.addRow(scanGridId, rowData, "first");
                continue;
            }

            stockCode = (js.String.roughScale(BarCodeArray[i].substr(3,5), 36)).toString();

            if(stockCode == "0"){
                failSound = true;
                rowData = {
                        "serialNo":BarCodeArray[i]
                      , "status":0
                      , "desc":"Serial No. Does Not Exist.",
                    };
                AUIGrid.addRow(scanGridId, rowData, "first");
                continue;
            }

             barInfo.push({   "serialNo":BarCodeArray[i]
                           , "transitNo":$('#sTransitNo').val()
                         });
        }

        console.log("barInfo.length" + barInfo.length);
        if(barInfo.length > 0){
            Common.ajax("POST", "/services/hiCare/saveHiCareDeliveryBarcode.do"
                    , {"barList":barInfo}
                    , function(result){
                        $.each(result.dataList, function(idx, row){
                            if(row.status == 0){
                                failSound = true;
                            }
                            AUIGrid.addRow(scanGridId, row, "first");
                        });

                        if(!msIe){
                            if(failSound){
                                //beep(999, 210, 800); beep(999, 500, 800);
                                $("#txtBarcode").val("");
                                $("#txtBarcode").focus();
                            }else{
                                //beep(100, 520, 200);
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
                //beep(999, 210, 800); beep(999, 500, 800);
                $("#txtBarcode").val("");
                $("#txtBarcode").focus();
            }
        }

        $("#txtBarcode").val("");
        $("#txtBarcode").focus();
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
  	$("#btnPopSearch").click();
  	$('#serialScanPop').remove();
}

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Hi-Care Serial No. Scanning</h1>
<ul class="right_opt">
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
			<tr id="typeUS">
			    <th scope="row">Transit No.</th>
			    <td colspan="3" >
			        <input type="text" id="sTransitNo" name="sTransitNo" placeholder="" class="w100p readonly" style="min-width:150px" readonly value=""'/>
			    </td>
			</tr>
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
