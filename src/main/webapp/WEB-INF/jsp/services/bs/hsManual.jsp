<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


    <script type="text/javaScript" language="javascript">


        var StatusTypeData = [{"codeId": "1","codeName": "Active"},{"codeId": "4","codeName": "Completed"},{"codeId": "21","codeName": "Failed"},{"codeId": "10","codeName": "Cancelled"}];
       var gradioVal = $("input:radio[name='searchDivCd']:checked").val();

        // AUIGrid 생성 후 반환 ID
        var myGridID;
        var gridValue;

        var option = {
                width : "1000px", // 창 가로 크기
                height : "600px" // 창 세로 크기
            };


                // 그리드 속성 설정
/*                 var gridPros = {
                    // 페이징 사용
                    usePaging : true,
                    // 한 화면에 출력되는 행 개수 20(기본값:20)
                    pageRowCount : 20,

                    editable : false,

                    //showStateColumn : true,

                    displayTreeOpen : true,


                    headerHeight : 30,

                    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
                    skipReadonlyColumns : true,

                    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
                    wrapSelectionMove : true,

                    // 줄번호 칼럼 렌더러 출력
                    showRowNumColumn : true

                    // 체크박스 표시 설정
//                    showRowCheckColumn : true,
                    // 전체 체크박스 표시 설정
   //                 showRowAllCheckBox : true

                };     */


        function fn_close(){
            window.close();
        }


       var columnManualLayout = [ {
                            dataField:"rnum",
                            headerText:"RowNum",
                            width:120,
                            height:30
                            ,
                            visible:false
                              }, {
                            dataField : "custId",
                            headerText : "Customer",
                            width : 120
                        }, {
                            dataField : "name",
                            headerText : "Customer Name",
                            width : 120
                       }, {
                            dataField : "salesOrdNo",
                            headerText : "Sales Order",
                            width : 120
                        }, {
                            dataField : "hsDate",
                            headerText : "HS Date",
                            width : 120                             ,
                            visible:false
                        }, {
                            dataField : "no",
                            headerText : "HS Order",
                            width : 120
                        }, {
                            dataField : "c5",
                            headerText : "Assign Cody",
                            width : 120
                        }, {
                            dataField : "codyStatus",
                            headerText : "Cody Status",
                            width : 120
                        }, {
                            dataField : "code",
                            headerText : "HS Status",
                            width : 120
                        }, {
                            dataField : "month",
                            headerText : "Complete Cody",
                            width : 120                             ,
                            visible:false
                        }, {
                            dataField : "brnchId",
                            headerText : "Branch",
                            width : 120
                             ,
                            visible:false
                        }, {
                            dataField : "schdulId",
                            headerText : "schdulId",
                            width : 120                                 ,
                            visible:false
                          /*     ,
                            visible:false      */
                        }, {
                            dataField : "salesOrdId",
                            headerText : "salesOrdId",
                            width : 120
                            ,
                            visible:false
                        }, {
                            dataField : "codyBrnchCode",
                            headerText : "Branch Code",
                            width : 120
                    },{
                        dataField : "codyMangrUserId",
                        headerText : "Cody Manager",
                        width : 120
                    },
                    {
                        dataField : "address",
                        headerText : "Installation Address",
                        width : 120}
                    , {
                            dataField : "stkDesc",
                            headerText : "Stock Name",
                            width : 120}
                    , {
                                dataField : "hsFreq",
                                headerText : "HS Frequency",
                                width : 120}
                    , {
                        dataField : "prevMthHsStatus",
                        headerText : "Previous Month Hs Result",
                        width : 120}
                    ];


            var columnAssiinLayout = [ {
                        dataField:"rnum",
                        headerText:"RowNum",
                        width:120,
                        height:30
                        ,
                        visible:false
                          }, {
                        dataField : "custId",
                        headerText : "Customer",
                        width : 120
                    }, {
                        dataField : "name",
                        headerText : "Customer Name",
                        width : 120
                   }, {
                        dataField : "salesOrdNo",
                        headerText : "Sales Order",
                        width : 120
                    }, {
                        dataField : "hsDate",
                        headerText : "HS Period",
                        width : 120
                    }, {
                        dataField : "no",
                        headerText : "HS Order",
                        width : 120
                    }, {
                        dataField : "c5",
                        headerText : "Assign Cody",
                        width : 120
                    },{
                        dataField : "deptCode",
                        headerText : "Department",
                        width : 120
                    }
                    /*,{
                        dataField : "actnMemId",
                        headerText : "Complete Cody",
                        width : 120
                    }*/
                    , {
                        dataField : "codyStatusNm",
                        headerText : "Cody Status",
                        width : 120
                    }, {
                        dataField : "code",
                        headerText : "HS Status",
                        width : 120
                    }, {
                        dataField : "branchCd",
                        headerText : "Branch CD",
                        width : 120
                     }, {
                        dataField : "codyMangrUserId",
                        headerText : "Cody Manager",
                        width : 120
                    }, {
                        dataField : "stusCodeId",
                        headerText : "HS Statuscd",
                        width : 120 ,
                        visible:false
                    }, {
                        dataField : "brnchId",
                        headerText : "Branch",
                        width : 120
                        ,
                        visible:false
                    }, {
                        dataField : "schdulId",
                        headerText : "schdulId",
                        width : 120
                           ,
                        visible:false
                    }, {
                        dataField : "salesOrdId",
                        headerText : "salesOrdId",
                        width : 120,
                        visible:false
                     },{
                        dataField : "result",
                        headerText : "result",
                        width : 120
                         ,
                        visible:false
                     },{
                        dataField : "undefined",
                        headerText : "Edit",
                        width : 170,
                        renderer : {
                              type : "ButtonRenderer",
                              labelText : "Edit",
                              onclick : function(rowIndex, columnIndex, value, item) {

                                   if(item.result == "" || item.result == undefined) {
                                        Common.alert('Not able to EDIT for the HS order status in Active.');
                                        return false;
                                   }

                                  $("#_schdulId").val(item.schdulId);
                                  $("#_salesOrdId").val(item.salesOrdId);
                                  $("#_openGb").val("edit");
                                  $("#_brnchId").val(item.brnchId);

                                  Common.popupDiv("/services/bs/hsBasicInfoPop.do?MOD=EDIT", $("#popEditForm").serializeJSON(), null , true , '');
                  }
           }
                }];



        function createAUIGrid(){
                // AUIGrid 칼럼 설정


                            //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
                        //myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
            }



/*         //전체 체크/해제 하기
        var allChecked = false;
        function setAllCheckedRows() {
            allChecked = !allChecked;
            AUIGrid.setAllCheckedRows(myGridID, allChecked);
        }; */



         // 리스트 조회.
        function fn_getBSListAjax() {

                var radioVal = $("input:radio[name='searchDivCd']:checked").val();

                if (radioVal == 1 ){ //hs_no  Create before
                	
                    if ($("#cmdBranchCode").val() == '' || $("#cmdBranchCode").val() == null) {
                    	Common.alert("Please Select 'Cody Branch'");
                        return false;
                    }
                    
                    if ( $("#userType").val() == "2") {
	                    if ( $("#memberLevel").val()  == "3" ||  $("#memberLevel").val()  == "4") {
		                    if ($("#cmdCdManager").val() == '' || $("#cmdCdManager").val() == null) {
		                        Common.alert("Please Select 'Cody Manager'");
		                        return false;
		                    } 
	                    }
                	}
                    Common.ajax("GET", "/services/bs/selectHsAssiinlList.do", $("#searchForm").serialize(), function(result) {

                        console.log("성공.");
                        console.log("data : " + result);
                        AUIGrid.setGridData(myGridID, result);
                     });
                }else {//hs_no  Create after

                    $("#brnchId1").val($("#cmdBranchCode1 option:selected").text());
                    var HsCdBranch = $('#brnchId1').val();
                    if($('#brnchId1').val().substring(0,3) != "CDB" ){
                        HsCdBranch = "";
                    }

                    $("#memId1").val($("#cmdCdManager1 option:selected").text());
                    var memId = $("#memId1").val();
                    if ($("#memId1").val().substring(0,3) != "CCS"){
                        memId = "";
                    }

                    if ($("#cmdBranchCode1").val() == '' || $("#cmdBranchCode1").val() == null) {
                        Common.alert("Please Select 'Branch'");
                        return false;
                    }
                    if ( $("#userType").val() == "2") {
	                    if ( $("#memberLevel").val()  == "3" ||  $("#memberLevel").val()  == "4") {
	                        if ($("#cmdCdManager1").val() == '' || $("#cmdCdManager1").val() == null) {
	                            Common.alert("Please Select 'Cody Manager'");
	                            return false;
	                        } 
	                    }
                   } 
                   
                       // Common.ajax("GET", "/services/bs/selectHsManualList.do", {ManuaSalesOrder:$("#ManuaSalesOrder").val(),ManuaMyBSMonth:$("#ManuaMyBSMonth").val(),ManualCustomer:$("#manualCustomer").val(),cmdBranchCode1:$("#brnchId1").val(),cmdCdManager1:$("#memId1").val()}, function(result) {
                   Common.ajax("GET", "/services/bs/selectHsManualList.do", {ManuaSalesOrder:$("#ManuaSalesOrder").val(),ManuaMyBSMonth:$("#ManuaMyBSMonth").val(),ManualCustomer:$("#manualCustomer").val(),cmdBranchCode1:HsCdBranch,cmdCdManager1:memId}, function(result) {
                       console.log("성공.");
                       console.log("data : " + result);
                       AUIGrid.setGridData(myGridID, result);
                   });
                }

          }






            function fn_getHSAddListAjax(){
            	
//             Common.popupDiv("/services/addInstallationPopup.do?isPop=true&installEntryId=" + installEntryId+"&codeId=" + codeid1);
                var checkedItems = AUIGrid.getCheckedRowItemsAll(myGridID);

                if(checkedItems.length <= 0) {
                    Common.alert('No data selected.');
                    return;
                } else if (checkedItems.length >= 2) {
                	Common.alert('Only availbale to entry a result with single HS order');
                    return;
                } else{
                    var str = "";
                    var custStr = "";
                    var rowItem;
                    var brnchId = "";
                    var saleOrdList = "";
                    var list = "";
                    var brnchCnt = "";

                    //var saleOrdList = [];
                    var saleOrd = {
                         salesOrdNo : ""
                    };



                    for(var i=0, len = checkedItems.length; i<len; i++) {
                        rowItem = checkedItems[i];
                        hsStuscd = rowItem.stusCodeId;
                        schdulId = rowItem.schdulId;
                        salesOrdId = rowItem.salesOrdId;

                         if(hsStuscd == 4) {
                            Common.alert("already has result. Result entry is disallowed.");
                            return;
                         }
                    }
                }





/*                 alert(AUIGrid.getCellValue(myGridID, event.rowIndex, "stusCodeId"));
                alert(hsStuscd);

                 if(hsStuscd == 4) {
                    Common.alert("already has result. Result entry is disallowed.");
                    return;
                 } */

               Common.popupDiv("/services/bs/selectHsInitDetailPop.do?isPop=true&schdulId=" + schdulId + "&salesOrdId="+ salesOrdId ,null ,null, true, '_hsDetailPopDiv');
                //Common.popupDiv("/sales/pos/selectPosViewDetail.do", $("#detailForm").serializeJSON(), null , true , '_editDiv');
            }



        $(function(){
           $("#codyChange").click(function(){
           $("#_openGb").val("codyChange");

            var checkedItems = AUIGrid.getCheckedRowItemsAll(myGridID);
          

            if(checkedItems.length <= 0) {
                Common.alert('No data selected.');
                return false;
            }else{
            	
            	
            if(checkedItems.length > 1){
            	 Common.alert('please choose one data selected.');
            	 return false;
            }
                var str = "";
                var custStr = "";
                var rowItem;
                var brnchId = "";
                var saleOrdList = "";
                var list = "";
                var brnchCnt = 0;
                var ctBrnchCodeOld = "";
                var dept="";

                //var saleOrdList = [];
                var saleOrd = {
                     salesOrdNo : ""
                };




                for(var i=0, len = checkedItems.length; i<len; i++) {
                    rowItem = checkedItems[i];
                    saleOrdList += rowItem.salesOrdNo;

                    if(i  != len -1){
                        saleOrdList += ",";
                    }

                    //동일 brnch 만 수정하도록
                    if(i !=0 ){
                        if(ctBrnchCodeOld != rowItem.codyBrnchCode ){
                            brnchCnt += 1 ;
                        }
                    }
                    ctBrnchCodeOld = rowItem.codyBrnchCode;
                    
                    if(i==0){
                         brnchId = rowItem.branchCd;
                    }

                    //상태 com은 수정 못하도록
                     if(rowItem.stusCodeId == "4"){
                        Common.alert('Not Allow to Cody Transfer for Complete HS Order');
                        return ;
                     }


                     dept = rowItem.deptCode;
               

                }

                var jsonObj = {
                         "SaleOrdList" : saleOrdList,
                         "BrnchId": brnchId,
                         "ManualCustId" : $("#manualCustomer").val(),
                         "ManuaMyBSMonth" : $("#ManuaMyBSMonth").val(),
                         "department" : dept
                         
                };


                  Common.popupDiv("/services/bs/selecthSCodyChangePop.do?isPop=true&JsonObj="+jsonObj+"&CheckedItems="+saleOrdList+"&BrnchId="+brnchId +"&ManuaMyBSMonth="+$("#ManuaMyBSMonth").val()  +"&department="+ dept );

            }

        });
    });




        $(function(){
           $("#hSConfiguration").click(function(){
           $("#_openGb").val("hsConfig");

            var checkedItems = AUIGrid.getCheckedRowItemsAll(myGridID);

            if(checkedItems.length <= 0) {
                Common.alert('No data selected.');
                return false;
            }else{
                var str = "";
                var custStr = "";
                var rowItem;
                var brnchId = "";
                var saleOrdList = "";
                var list = "";
                var brnchCnt = 0;
                var ctBrnchCodeOld = "";

                //var saleOrdList = [];
                var saleOrd = {
                     salesOrdNo : ""
                };



                for(var i=0, len = checkedItems.length; i<len; i++) {
                    rowItem = checkedItems[i];
                    saleOrdList += rowItem.salesOrdNo;


                    var hsStutus = rowItem.code;
                    if( hsStutus == "COM") {
                        Common.alert("<b>  do no has result COM..");
                        return ;
                    }



                    if(i  != len -1){
                        saleOrdList += ",";
                    }

                    if(i !=0 ){
                        if(ctBrnchCodeOld != rowItem.codyBrnchCode ){
                            brnchCnt += 1 ;
                        }
                    }

                    ctBrnchCodeOld = rowItem.codyBrnchCode;


                    if(i==0){
                         brnchId = rowItem.brnchId;
                    }


                }




                if(brnchCnt > 0 ){
                    Common.alert("Not Avaialable to Create HS Order With Several CDB in Single Time.");
                    return;
                }

                var jsonObj = {
                         "SaleOrdList" : saleOrdList,
                         "BrnchId": brnchId,
                         "ManualCustId" : $("#manualCustomer").val(),
                         "ManuaMyBSMonth" : $("#ManuaMyBSMonth").val()
                };

                Common.ajax("GET", "/services/bs/selectHsOrderInMonth.do?saleOrdList="+saleOrdList+"&ManuaMyBSMonth=" + $("#ManuaMyBSMonth").val(),"" , function(result){
                	 console.log(result);
                	if(result.message == "success"){
                		Common.alert("There is already exist for HS order for this month");
                		return;
                	}
                	else{
                		Common.popupDiv("/services/bs/selectHSConfigListPop.do?isPop=true&JsonObj="+jsonObj+"&CheckedItems="+saleOrdList+"&BrnchId="+brnchId +"&ManuaMyBSMonth="+$("#ManuaMyBSMonth").val()  );
                	}
                	
                	
                });
                

                

            }

        });
    });



/*           AUIGrid.bind(myGridID, "cellClick", function(event) {
                custId =  AUIGrid.getCellValue(myGridID, event.rowIndex, "custId");
            });  */


        //Start AUIGrid
        $(document).ready(function() {

              doDefCombo(StatusTypeData, '' ,'cmbStatusType', 'S', '');

              $('#myBSMonth').val($.datepicker.formatDate('mm/yy', new Date()));
              $('#ManuaMyBSMonth').val($.datepicker.formatDate('mm/yy', new Date()));

                // AUIGrid 그리드를 생성합니다.
//                createAUIGrid();
//                AUIGrid.setSelectionMode(myGridID, "singleRow");

         $("#cmdBranchCode").click(function() {
            $("#cmdCdManager").find('option').each(function() {
                $(this).remove();
            });

      /*  Change to textBox -  txtcodyCode
      $("#cmdcodyCode").find('option').each(function() {
                $(this).remove();
            }); */
            
            if ($(this).val().trim() == "") {
                return;
            }
            if( $("#userType").val() != "3") {
                doGetCombo('/services/bs/getCdUpMemList.do', $(this).val() , ''   , 'cmdCdManager' , 'S', 'fn_cmdBranchCode');
            }
        });


         $("#cmdBranchCode1").click(function() {
             $("#cmdCdManager1").find('option').each(function() {
                 $(this).remove();
             });
      /*  HS Order Search used only and change to textBox
      $("#cmdcodyCode").find('option').each(function() {
                 $(this).remove();
             }); */

             if ($(this).val().trim() == "") {
                 return;
             }
             if( $("#userType").val() != "3") {
                doGetCombo('/services/bs/getCdDeptList.do', $(this).val() , ''   , 'cmdCdManager1' , 'S', 'fn_cmdBranchCode1');
             }   
         });


            /*By KV -  Change to textBox -  txtcodyCode and below code no more used.
           $("#cmdCdManager").change(function() {
                $("#cmdcodyCode").find('option').each(function() {
                    $(this).remove();
                });
                if ($(this).val().trim() == "") {
                    return;
                }
               doGetCombo('/services/bs/getCdList.do', $(this).val() , ''   , 'cmdcodyCode' , 'S', '');
            });*/

                fn_checkRadioButton();


            AUIGrid.bind(myGridID, "cellClick", function(event) {
                  //alert(event.rowIndex+ " -cellClick : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid"));
                  schdulId =  AUIGrid.getCellValue(myGridID, event.rowIndex, "schdulId");
                  salesOrdId = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId");
                  hsStuscd = AUIGrid.getCellValue(myGridID, event.rowIndex, "stusCodeId");
                  result =     AUIGrid.getCellValue(myGridID, event.rowIndex, "result");
                    //Common.popupDiv("/bs/selectHsInitDetailPop.do?isPop=true&schdulId=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "schdulId") + "&salesOrdId="+ AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId"));
              });

                 // 셀 더블클릭 이벤트 바인딩
                AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
                   var radioVal = $("input:radio[name='searchDivCd']:checked").val();

                    if(radioVal == 1 ){
/*                           _schdulId =  AUIGrid.getCellValue(myGridID, event.rowIndex, "schdulId");
                          _salesOrdId = AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId");
                          _brnchId = AUIGrid.getCellValue(myGridID, event.rowIndex, "brnchId"); */


                        $("#_schdulId").val(AUIGrid.getCellValue(myGridID, event.rowIndex, "schdulId"));
                        $("#_salesOrdId").val(AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId"));
                        $("#_brnchId").val(AUIGrid.getCellValue(myGridID, event.rowIndex, "brnchId"));
                        $("#_openGb").val("view");
                        $("#_manuaMyBSMonth").val($("#ManuaMyBSMonth").val());

/*                          alert("_schdulId::"+  $("#_schdulId").val() +  $("#_salesOrdId").val()+  $("#_brnchId").val()); */

                         var stid =AUIGrid.getCellValue(myGridID, event.rowIndex, "stusCodeId");

                         if(stid !=1 ){
                             Common.popupDiv("/services/bs/hsBasicInfoPop.do?MOD=VIEW", $("#popEditForm").serializeJSON(), null , true , '');
                         }
                    }
                });

            if ( $("#memberLevel").val() != "") {
            
                if ( $("#memberLevel").val()  == "4" ) {
                
                    $("#txtAssigncodyCode").val($("#userName").val()); 
                    $("#txtAssigncodyCode").attr("readOnly", true)
                
                }
                
                
            
                
                $("#cmdBranchCode option:eq(1)", '#searchForm').attr("selected", true);
                $("#cmdBranchCode1 option:eq(1)", '#searchForm').attr("selected", true);
                

                //$("#cmdCdManager1 option:eq(1)", '#searchForm').attr("selected", true); 
                

                $('#cmdBranchCode').trigger('click');
                $('#cmdBranchCode1').trigger('click');
                
                $('#cmdBranchCode', '#searchForm').attr("readonly", true );
                $('#cmdBranchCode1', '#searchForm').attr("readonly",  true );
                
                $('#cmdBranchCode', '#searchForm').attr('class','w100p readonly ');
                $('#cmdBranchCode1', '#searchForm').attr('class','w100p readonly ');
                
                /*$('#cmdCdManager', '#searchForm').attr("readonly", true );
                $('#cmdCdManager1', '#searchForm').attr("readonly",  true );
                
		        $('#cmdBranchCode', '#searchForm').attr("readonly", true );
		        $('#cmdBranchCode1', '#searchForm').attr("readonly",  true );
		        
		        $('#cmdBranchCode', '#searchForm').attr('class','w100p readonly ');
		        $('#cmdBranchCode1', '#searchForm').attr('class','w100p readonly ');
                */
            } 
        });

        function fn_checkRadioButton(objName){

            if( document.searchForm.elements['searchDivCd'][0].checked == true ) {
                        var divhsManuaObj = document.querySelector("#hsManua");
                        divhsManuaObj.style.display="none";
                        $('#hSConfiguration').attr('disabled',true); //hSConfiguration 버튼 비활성화

                        var divhsManagementObj = document.querySelector("#hsManagement");
                        divhsManagementObj.style.display="block";



                        //$('#hSConfiguration').attr('disabled',true); //hash
//                      $('#hSConfiguration').attr('disabled',false);  //SMS버튼 활성화
//

                        //2번영역 데이터 클리어
                        //fn_checkboxChangeHandler();
                        fn_destroyGridA();

                        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnAssiinLayout ,gridProsAssiin);
                        //createAssinAUIGrid(columnAssiinLayout);
            }else{

                        var divhsManagementObj = document.querySelector("#hsManagement");
                        divhsManagementObj.style.display="none";
                        $('#hSConfiguration').attr('disabled',false); //hSConfiguration 버튼 활성화

                        var divhsManuaObj = document.querySelector("#hsManua");
                        divhsManuaObj.style.display="block";

                        $("#addResult").attr("disabled",true);

                        //1번영역 데이터 클리어
                        $("#ManuaSalesOrder").val('');
//                        $("#ManuaMyBSMonth").val('');
                        $("#manualCustomer").val('');

//                      fn_checkboxChangeHandler();
                        fn_destroyGridM();

                        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnManualLayout ,gridProsManual);


            }
        }


            var gridProsAssiin = {
          // 페이징 사용
             usePaging : true,
          // 한 화면에 출력되는 행 개수 20(기본값:20)
             pageRowCount : 20,
             editable :  false,
             showRowCheckColumn : true
             };

           var gridProsManual = {
                 showRowCheckColumn : true,
                 // 페이징 사용
                 usePaging : true,
                 // 한 화면에 출력되는 행 개수 20(기본값:20)
                 pageRowCount : 20,
                 // 전체 체크박스 표시 설정
                 showRowAllCheckBox : true,
                 editable :  false
                 }

        // AUIGrid 를 생성합니다.
        function createAssinAUIGrid(columnAssiinLayout) {

          // 그리드 속성 설정
            // 실제로 #grid_wrap 에 그리드 생성
              myGridID = AUIGrid.create("#grid_wrap", columnAssiinLayout, gridProsAssiin);
        }


        // AUIGrid 를 생성합니다.
        function createManualAUIGrid(columnManualLayout) {

             // 그리드 속성 설정


            // 실제로 #grid_wrap 에 그리드 생성
              myGridID = AUIGrid.create("#grid_wrap", columnManualLayout, gridProsManual);
        }



        function fn_destroyGridA() {
            myGridID = null;

            AUIGrid.setProp(myGridID, gridProsAssiin );
            AUIGrid.destroy("#grid_wrap");
            createAssinAUIGrid(columnAssiinLayout);


        }


         function fn_destroyGridM() {

            myGridID = null;

            AUIGrid.setProp(myGridID, gridProsManual );
            AUIGrid.destroy("#grid_wrap");
            createManualAUIGrid(columnManualLayout);


        }

/*         function fn_destroyAssiinGrid() {
            AUIGrid.destroy("#grid_wrap");
            myAssiinlGridID = null;
        } */


        function fn_checkboxChangeHandler(event) {

            var radioVal = $("input:radio[name='searchDivCd']:checked").val();

            if(radioVal == 1 ){
                fn_destroyGrid();
                myGridID = GridCommon.createAUIGrid("grid_wrap", columnAssiinLayout ,gridProsAssiin);
            }else {
                fn_destroyGrid();
                myGridID = GridCommon.createAUIGrid("grid_wrap", columnManualLayout ,gridProsManual);
            }
        }

        function fn_hsCountForecastListing(){
            Common.popupDiv("/services/bs/report/hsCountForecastListingPop.do"  , null, null , true , '');
        }

        function fn_hsReportSingle(){
            Common.popupDiv("/services/bs/report/hsReportSinglePop.do"  , null, null , true , '');
        }
        function fn_hsReportGroup(){
            Common.popupDiv("/services/bs/report/hsReportGroupPop.do"  , null, null , true , '');
        }
        function fn_hsSummary(){
            Common.popupDiv("/services/bs/report/bSSummaryList.do"  , null, null , true , '');
        }
        
        function fn_filterForecastList(){
            Common.popupDiv("/services/bs/report/filterForecastListingPop.do"  , null, null , true , '');
        }
        




        function fn_cmdBranchCode() {
            if ( $("#memberLevel").val() == "3" ||  $("#memberLevel").val() == "4" ) {
	            $("#cmdCdManager option:eq(1)", '#searchForm').attr("selected", true);
	            $('#cmdCdManager', '#searchForm').attr("readonly", true );
	            $('#cmdCdManager', '#searchForm').attr('class','w100p readonly ');
            }
            
        }
        
        function fn_cmdBranchCode1() {
	        if ( $("#memberLevel").val() == "3" ||  $("#memberLevel").val() == "4" ) {
	        
	            $("#cmdCdManager1 option:eq(1)", '#searchForm').attr("selected", true);
	            $('#cmdCdManager1', '#searchForm').attr("readonly", true );
	            $('#cmdCdManager1', '#searchForm').attr('class','w100p readonly ');
	        }            
        }        
    </script>




<form id="popEditForm" method="post">
    <input type="hidden" name="schdulId"  id="_schdulId"/>  <!-- schdulId  -->
    <input type="hidden" name="salesOrdId"  id="_salesOrdId"/>  <!-- salesOrdId  -->
    <input type="hidden" name="openGb"  id="_openGb"/>  <!--   salesOrdId  -->
    <input type="hidden" name="brnchId"  id="_brnchId"/>  <!-- salesOrdId  -->
    <input type="hidden" name="manuaMyBSMonth"  id="_manuaMyBSMonth"/>  <!-- salesOrdId  -->
    <input type="hidden" id="brnchId1" name="brnchId1"> <!-- Manual branch -->
     <input type="hidden" id="memId1" name="memId1"> <!-- Manual branch -->
     
     <input type="hidden" id="memberLevel" name="memberLevel" value="${memberLevel}"> <!-- Manual branch -->
     
     <input type="hidden" id="userName" name="userName" value="${userName}"> 
     <input type="hidden" id="userType" name="userType" value="${userType}">
     
</form>

<%-- <form id="popEditViewForm" method="post">
    <input type="hidden" name="schdulId"  id="_schdulIdView"/>  <!-- schdulId  -->
    <input type="hidden" name="salesOrdId"  id="_salesOrdIdView"/>  <!-- salesOrdId  -->
    <input type="hidden" name="openGb"  id="_openGbView"/>  <!--   salesOrdId  -->
    <input type="hidden" name="brnchId"  id="_brnchIdView"/>  <!-- salesOrdId  -->
</form> --%>

<form id="searchForm" name="searchForm">


<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>HS Management</h2>
<ul class="right_btns">
     <li><p class="btn_blue"><a id="codyChange">Assign Cody Transfer</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_getHSAddListAjax();" id="addResult">Add HS Result</a></p></li>
    <li><p class="btn_blue"><a id="hSConfiguration" name="hSConfiguration">Create HS Order</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_getBSListAjax();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
</ul>
<!--조회조건 추가  -->
<!--     <label><input type="radio" name="searchDivCd" value="1" onClick="fn_checkRadioButton('comm_stat_flag')" checked />HS Order Search</label>
    <label><input type="radio" name="searchDivCd" value="2" onClick="fn_checkRadioButton('comm_stat_flag')" />Manual HS</label> -->
</aside><!-- title_line end -->


<div id="hsManagement" style="display:block;">
<form  id="hsManagement" method="post">

            <section class="search_table"><!-- search_table start -->
            <form action="#" method="post">

            <table class="type1"><!-- table start -->
            <caption>table</caption>
            <colgroup>
                <col style="width:110px" />
                <col style="width:*" />
                <col style="width:110px" />
                <col style="width:*" />
                <col style="width:100px" />
                <col style="width:*" />
                <col style="width:120px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
            <tr>
                <th scope="row">Cody Branch<span class="must">*</span></th>
                <td>
                <select id="cmdBranchCode" name="cmdBranchCode" class="w100p readOnly ">
                       <option value="">Choose One</option>
                       <c:forEach var="list" items="${branchList }" varStatus="status">
                       <option value="${list.codeId}">${list.codeName}</option>
                       </c:forEach>
                </select>
                </td>
                <th scope="row">Cody Manager</th>
                <td>
                    <select id="cmdCdManager" name="cmdCdManager" class="w100p">
                </td>
                    <th scope="row"> Assign Cody</th>
                <td>
                   <input id="txtAssigncodyCode" name="txtAssigncodyCode"  type="text" title="" placeholder="Cody" class="w100p" />

                <!-- By Kv - Change cmbBox to text Box -->
                <!-- <select class="w100p" id="cmdcodyCode" name="cmdcodyCode" > -->
                <!-- <option value="">cody</option> -->
                </td>
                <th scope="row"> Complete Cody</th>
                <td>
                   <input id="txtComcodyCode" name="txtComcodyCode"  type="text" title="" placeholder="Cody" class="w100p" />
                </td>
            </tr>
            <tr>
                <th scope="row">HS Order</th>
                <td>
                    <input id="txtHsOrderNo" name="txtHsOrderNo"  type="text" title="" placeholder="HS Order" class="w100p" />
                </td>
                <th scope="row">HS Period</th>
                <td>
                    <input id="myBSMonth" name="myBSMonth" type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" readonly />
                </td>
                 <th scope="row">HS Status</th>
                <td>
                    <select class="w100p"  id="cmbStatusType" name="cmbStatusType">
                 <option value="">HS Status</option>
                </td>
                <th scope="row">Customer</th>
                <td>
                    <input id="txtCustomer" name="txtCustomer"  type="text" title="" placeholder="Customer" class="w100p" />
                </td>
                </tr>
            <tr>
                <th scope="row">Sales Order</th>
                <td>
                    <input id="txtSalesOrder" name="txtSalesOrder"  type="text" title="" placeholder="Sales Order" class="w100p" />
                </td>
                <th scope="row">Install Month</th>
                <td>
                    <input id="myInstallMonth" name="myInstallMonth" type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p"  />
                </td>
                <th scope="row">Dept Code</th>
                <td>
                    <input id="deptCode" name="deptCode" type="text" title=""  placeholder="DEPT CODE" class="w100p" />
                </td>        
                <th scope="row"></th>
                <td>
                    
                </td>   
            </tr>

            </tbody>
            </table><!-- table end -->

            <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
            <!-- <p class="show_btn"><a href="#"><img src="../images/common/btn_link.gif" alt="link show" /></a></p> -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
            <dl class="link_list">
                <dt>Link</dt>
                <dd>
                    <ul class="btns">
                        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_hsCountForecastListing()">HS Count Forecast Listing</a></p></li>
                        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_hsReportSingle()">HS History</a></p></li>
                        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_hsReportGroup()">HS Report(Group)</a></p></li>
                        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_hsSummary()">HS Summary Listing</a></p></li>
                        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_filterForecastList()">HS Filter Forecast Listring</a></p></li>
                    </ul>
<!--              <ul class="btns">
                    <li><p class="link_btn"><a href="#">menu1</a></p></li>
                    <li><p class="link_btn"><a href="#">menu2</a></p></li>
                    <li><p class="link_btn"><a href="#">menu3</a></p></li>
                    <li><p class="link_btn"><a href="#">menu4</a></p></li>
                    <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
                    <li><p class="link_btn"><a href="#">menu6</a></p></li>
                    <li><p class="link_btn"><a href="#">menu7</a></p></li>
                    <li><p class="link_btn"><a href="#">menu8</a></p></li>
                </ul>
                <ul class="btns">

                </ul> -->
                <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                </dd>
            </dl>
            </aside><!-- link_btns_wrap end -->

            </form>
            </section><!-- search_table end -->
</form>
</div>



<div id="hsManua" style="display:block;">
<form  id="hsManua" method="post">

            <section class="search_table"><!-- search_table start -->
            <form action="#" method="post">

            <table class="type1"><!-- table start -->
            <caption>table</caption>
            <colgroup>
                <col style="width:100px" />
                <col style="width:*" />
                <col style="width:100px" />
                <col style="width:*" />
                <col style="width:100px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
            <tr>
                <th scope="row">Sales Order</th>
                <td>
                    <input id="ManuaSalesOrder" name="ManuaSalesOrder"  type="text" title="" placeholder="Sales Order" class="w100p" />
                </td>
                <th scope="row">HS Period</th>
                <td>
                    <input id="ManuaMyBSMonth" name="ManuaMyBSMonth" type="text" title="기준년월" placeholder="MM/YYYY" class="j_date2 w100p" readonly />
                </td>
                <th scope="row">Customer</th>
                <td>
                    <input id="manualCustomer" name="manualCustomer"  type="text" title="" placeholder="Customer" class="w100p" />
                </td>

            </tr>
            <tr>
            <th scope="row">Branch<span class="must">*</span></th>
            <td>
            <select id="cmdBranchCode1" name="cmdBranchCode1" class="w100p">
                       <option value="">Choose One</option>
                       <c:forEach var="list" items="${branchList }" varStatus="status">
                       <option value="${list.codeId}">${list.codeName}</option>
                       </c:forEach>
                </select>
            </td>
            <th scope="row">Cody Manager</th>
            <td colspan="3">
            <select id="cmdCdManager1" name="cmdCdManager1" class="" >
            </td>
            </tr>
            </tbody>
            </table><!-- table end -->

            <aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<%--             <p class="show_btn"><a href="#"><br><br><br><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p> --%>
            <%-- <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p> --%>
            <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
            <dl class="link_list">
                <dt>Link</dt>
                <dd>
                <ul class="btns">
                </ul>
                <ul class="btns">
                </ul>
                <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
                </dd>
            </dl>
            </aside><!-- link_btns_wrap end -->

            </form>
            </section><!-- search_table end -->
</form>
</div>

                <label><input type="radio" name="searchDivCd" value="1" onClick="fn_checkRadioButton('comm_stat_flag')" checked />HS Order Search</label>
                <label><input type="radio" name="searchDivCd" value="2" onClick="fn_checkRadioButton('comm_stat_flag')" />Manual HS</label><br><br>

    <ul class="right_btns">


    </ul>

<section class="search_result"><!-- search_result start -->

<!-- <ul class="right_btns">
    <li><p class="btn_grid"><a id="hSConfiguration">HS Order Create</a></p></li>
</ul> -->
<!-- <ul class="right_btns">
    <li><p class="btn_grid"><a href="#" " onclick="javascript:fn_getHSConfAjax();">HS Configuration</a></p></li>
</ul> -->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" style="width: 100%; height: 800px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<ul class="center_btns">
<!--     <li><p class="btn_blue2"><a href="#">Cody Assign</a></p></li> -->
</ul>

</section><!-- content end -->
</form>

<!-- 

    <div class="popup_wrap" id="confiopenwindow" style="display:none">popup_wrap start
        <header class="pop_header">pop_header start
            <section id="content">content start
            <ul class="path">
                <li><img src="../images/common/path_home.gif" alt="Home" /></li>
                <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
            </ul>
         </header>pop_header end
        <aside class="title_line">title_line start
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>BS Management</h2>
        </aside>title_line end

        <div class="divine_auto">divine_auto start

        <div style="width:20%;">

        <aside class="title_line">title_line start
        <h3>Cody List</h3>
        </aside>title_line end

        <div class="border_box" style="height:400px">border_box start

        <ul class="right_btns">
            <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
            <li><p class="btn_grid"><a href="#">NEW</a></p></li>
        </ul>

        <article class="grid_wrap">grid_wrap start
        </article>grid_wrap end

        </div>border_box end

        </div>

        <div style="width:50%;">

        <aside class="title_line">title_line start
        <h3>HS Order List</h3>
        </aside>title_line end

        <div class="border_box" style="height:400px">border_box start

        <ul class="right_btns">
            <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
            <li><p class="btn_grid"><a href="#">NEW</a></p></li>
        </ul>

        <article class="grid_wrap">grid_wrap start
        </article>grid_wrap end
-
        <ul class="center_btns">
            <li><p class="btn_blue2"><a href="#">Assign Cody Change</a></p></li>
            <li><p class="btn_blue2"><a href="#">Cody Assign</a></p></li>
            <li><p class="btn_blue2"><a href="#">HS Transfer</a></p></li>
        </ul>

        </div>border_box end

        </div>

        <div style="width:30%;">

        <aside class="title_line">title_line start
        <h3>Cody – HS Order</h3>
        </aside>title_line end

        <div class="border_box" style="height:400px">border_box start

        <ul class="right_btns">
            <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
            <li><p class="btn_grid"><a href="#">NEW</a></p></li>
        </ul>

        <article class="grid_wrap">grid_wrap start
        </article>grid_wrap end

        <ul class="center_btns">
            <li><p class="btn_blue2"><a href="#">Confirm</a></p></li>
        </ul>

        </div>border_box end

        </div>

        </div>divine_auto end

        </section>content end
    </div> -->