<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<meta name="viewport" content="width=device-width, initial-scale=1">

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/bootstrap-5.0.2-dist/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/customerMain.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/customerCommon.css"/>
<script src="https://unpkg.com/masonry-layout@4/dist/masonry.pkgd.min.js"></script>
<script src="https://unpkg.com/html5-qrcode"></script>

<style>
      .btn-tag {
        background-color: #ECEFF1;
        text-transform: capitalize !important;
        margin-bottom: 10px;
        box-shadow: none;
      }

      .btn-tag:hover {
        box-shadow: 0 2px 5px 0 rgba(0, 0, 0, .25), 0 3px 10px 5px rgba(0, 0, 0, 0.05) !important;
      }

      .grid-item {
        width: 50%;
      }

      .grid-item img {
        width: 100%;
      }

      .foto:before {
        content: url("data:image/svg+xml, %3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%2216%22%20height%3D%2216%22%20fill%3D%22currentColor%22%20class%3D%22bi%20bi-images%22%20viewBox%3D%220%200%2016%2016%22%3E%0A%20%20%3Cpath%20d%3D%22M4.502%209a1.5%201.5%200%201%200%200-3%201.5%201.5%200%200%200%200%203z%22%2F%3E%0A%20%20%3Cpath%20d%3D%22M14.002%2013a2%202%200%200%201-2%202h-10a2%202%200%200%201-2-2V5A2%202%200%200%201%202%203a2%202%200%200%201%202-2h10a2%202%200%200%201%202%202v8a2%202%200%200%201-1.998%202zM14%202H4a1%201%200%200%200-1%201h9.002a2%202%200%200%201%202%202v7A1%201%200%200%200%2015%2011V3a1%201%200%200%200-1-1zM2.002%204a1%201%200%200%200-1%201v8l2.646-2.354a.5.5%200%200%201%20.63-.062l2.66%201.773%203.71-3.71a.5.5%200%200%201%20.577-.094l1.777%201.947V5a1%201%200%200%200-1-1h-10z%22%2F%3E%0A%3C%2Fsvg%3E");
        margin-right: 10px;
        transform: translate(0, 10%);
      }

      .kamera:before {
        content: url("data:image/svg+xml, %3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%2216%22%20height%3D%2216%22%20fill%3D%22currentColor%22%20class%3D%22bi%20bi-camera%22%20viewBox%3D%220%200%2016%2016%22%3E%0A%20%20%3Cpath%20d%3D%22M15%2012a1%201%200%200%201-1%201H2a1%201%200%200%201-1-1V6a1%201%200%200%201%201-1h1.172a3%203%200%200%200%202.12-.879l.83-.828A1%201%200%200%201%206.827%203h2.344a1%201%200%200%201%20.707.293l.828.828A3%203%200%200%200%2012.828%205H14a1%201%200%200%201%201%201v6zM2%204a2%202%200%200%200-2%202v6a2%202%200%200%200%202%202h12a2%202%200%200%200%202-2V6a2%202%200%200%200-2-2h-1.172a2%202%200%200%201-1.414-.586l-.828-.828A2%202%200%200%200%209.172%202H6.828a2%202%200%200%200-1.414.586l-.828.828A2%202%200%200%201%203.172%204H2z%22%2F%3E%0A%20%20%3Cpath%20d%3D%22M8%2011a2.5%202.5%200%201%201%200-5%202.5%202.5%200%200%201%200%205zm0%201a3.5%203.5%200%201%200%200-7%203.5%203.5%200%200%200%200%207zM3%206.5a.5.5%200%201%201-1%200%20.5.5%200%200%201%201%200z%22%2F%3E%0A%3C%2Fsvg%3E");
        margin-right: 10px;
        transform: translate(0, 10%);
      }

      .tangkap:before {
         content: url("data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%2216%22%20height%3D%2216%22%20fill%3D%22currentColor%22%20class%3D%22bi%20bi-aspect-ratio%22%20viewBox%3D%220%200%2016%2016%22%3E%0A%20%20%3Cpath%20d%3D%22M0%203.5A1.5%201.5%200%200%201%201.5%202h13A1.5%201.5%200%200%201%2016%203.5v9a1.5%201.5%200%200%201-1.5%201.5h-13A1.5%201.5%200%200%201%200%2012.5v-9zM1.5%203a.5.5%200%200%200-.5.5v9a.5.5%200%200%200%20.5.5h13a.5.5%200%200%200%20.5-.5v-9a.5.5%200%200%200-.5-.5h-13z%22%2F%3E%0A%20%20%3Cpath%20d%3D%22M2%204.5a.5.5%200%200%201%20.5-.5h3a.5.5%200%200%201%200%201H3v2.5a.5.5%200%200%201-1%200v-3zm12%207a.5.5%200%200%201-.5.5h-3a.5.5%200%200%201%200-1H13V8.5a.5.5%200%200%201%201%200v3z%22%2F%3E%0A%3C%2Fsvg%3E");
         margin-right: 10px;
         transform: translate(0, 10%);
      }
</style>

<div style="min-height: 100vh; flex-direction:column;" class="d-flex align-items-center mainBackground" id="page1">
        <div style="flex:1; justify-content:end;" class="flexColumn">
                <div class="mb-5"><img src="${pageContext.request.contextPath}/resources/images/common/logo_coway.gif" alt="Coway"></div>
        </div>
        <div class="container-fluid" style="flex:2">
               <div class="card mainBorderColor m-auto" style="max-width:576px">
                        <div style="transform:translate(0%,-50%);" class="d-flex justify-content-center">
                            <h5 class="header">Imbas Nombor Bersiri</h5>
                        </div>
                        <div class="card-body m-4 mainBorderColor">
                        <form>
                           <div class="form-outline mb-3">
                                 <h5>&nbsp;Pilihan:</h5>
                                 <select class="form-control" id="optionVal">
                                         <option value="" selected>Imbas Kod Bar</option>
                                         <option value="1">Lampirkan Gambar</option>
                                 </select>
                            </div>
                            <div id="barcodeSection">
							    <div id="qr-reader"></div>
							    <div id="qr-reader-results"></div>
							    <h2 id="serialNo"></h2>
							     <div class="form-group">
							        <p class="btn btn-primary btn-block btn-lg" id="btnScanBarcode">
							            <a href="javascript:void(0);" style="color: white">Imbas Kod Bar Dalaman</a>
							        </p>
							         <h2 id="serialNo2"></h2>
							         <p class="btn btn-primary btn-block btn-lg" id="btnScanBarcodeOutdoor">
	                                    <a href="javascript:void(0);" style="color: white">Imbas Kod Bar Luaran</a>
	                                </p>
							    </div>
                            </div>
                            <div id="imageSection"></div>
                        </form>
                        </div>
                        <div class="row justify-content-center mt-3">
                               <div class="col-5">
                                    <div class="form-group">
                                         <p class="btn btn-primary btn-block btn-lg"  id="btnBackMain" style="background:#B1D4E7  !important"><a href="javascript:void(0);" style="color:white">Kembali</a></p>
                                    </div>
                              </div>
                              <div class="col-5">
                                    <div class="form-group">
                                         <p class="btn btn-primary btn-block btn-lg"  id="btnNextPage2" style="background:#4f90d6 !important"><a href="javascript:void(0);" style="color:white">Seterusnya</a></p>
                                    </div>
                              </div>
                        </div>
                </div>
        </div>
</div>

<div style="min-height: 100vh; flex-direction:column;display:none;" class="align-items-center mainBackground" id="page2">
        <div style="flex:1; justify-content:end;" class="flexColumn">
                <div class="mb-5"><img src="${pageContext.request.contextPath}/resources/images/common/logo_coway.gif" alt="Coway"></div>
        </div>
        <div class="container-fluid" style="flex:2">
               <div class="card mainBorderColor m-auto" style="max-width:576px">
                        <div style="transform:translate(0%,-50%);" class="d-flex justify-content-center">
                            <h5 class="header">Foto Diperlukan</h5>
                        </div>
                        <div class="card-body m-4 mainBorderColor">
                        <form>
                        <div id="sirimUploadContainer"></div>
                        <div id="installUploadContainer"></div>
                        </form>
                        </div>
                        <div class="row justify-content-center mt-3">
                               <div class="col-5">
                                    <div class="form-group">
                                         <p class="btn btn-primary btn-block btn-lg"  id="btnBackPage1" style="background:#B1D4E7  !important"><a href="javascript:void(0);" style="color:white">Kembali</a></p>
                                    </div>
                              </div>
                              <div class="col-5">
                                    <div class="form-group">
                                         <p class="btn btn-primary btn-block btn-lg"  id="btnNextPage3" style="background:#4f90d6 !important"><a href="javascript:void(0);" style="color:white">Seterusnya</a></p>
                                    </div>
                              </div>
                        </div>
                </div>
        </div>
</div>


<div style="min-height: 100vh; flex-direction:column;display:none;" class="align-items-center mainBackground" id="page3">
        <div style="flex:1; justify-content:end;" class="flexColumn">
                <div class="mb-5"><img src="${pageContext.request.contextPath}/resources/images/common/logo_coway.gif" alt="Coway"></div>
        </div>
        <div class="container-fluid" style="flex:2">
               <div class="card mainBorderColor m-auto" style="max-width:576px">
                        <div style="transform:translate(0%,-50%);" class="d-flex justify-content-center">
                            <h5 class="header">Pengesahan</h5>
                        </div>
                        <div class="card-body m-4 mainBorderColor">
                                <div class="row">
                                      <div class="col-6"><h4>Nombor Pemasangan: </h4></div>
                                      <div class="col-6"><h4 class="font-weight-bold">${installationInfo.installEntryNo}</h4></div>
                                </div>
                                <div class="row">
                                          <div class="col-6"><h5>Nombor Pesanan: </h5></div>
                                          <div class="col-6"><h5>${installationInfo.salesOrdNo}</h5></div>
                                 </div>
                                <div class="row">
                                     <div class="col-6"><h5>Tarikh Pesanan: </h5></div>
                                     <div class="col-6"><h5 id="salesDt"></h5></div>
                                </div>
                                <div class="row">
                                     <div class="col-6"><h5>Tarikh Temu Janji: </h5></div>
                                     <div class="col-6"><h5 id="doDt"></h5></div>
                                </div>
                                <div class="row">
                                     <div class="col-6"><h5>Catatan:</h5></div>
                                </div>
                                <div class="row">
                                     <div class="col-12"><textarea id="remark"  rows="4" cols="50"></textarea></div>
                                </div>
                                <div class="row" style="display:none;" id="completeTitle">
                                     <div class="col-6"><h4 class="text-danger">Lengkap: </h4></div>
                                </div>
                                <div id="displayUploadContainer"></div>
                        </div>
                        <div class="row justify-content-center mt-3">
                               <div class="col-5">
                                    <div class="form-group">
                                         <p class="btn btn-primary btn-block btn-lg"  id="btnBackPage2" style="background:#B1D4E7  !important"><a href="javascript:void(0);" style="color:white">Kembali</a></p>
                                    </div>
                              </div>
                              <div class="col-5">
                                    <div class="form-group">
                                         <p class="btn btn-primary btn-block btn-lg"  id="btnSubmit" style="background:#4f90d6 !important"><a href="javascript:void(0);" style="color:white">Hantar</a></p>
                                    </div>
                              </div>
                        </div>
                </div>
        </div>
</div>


<input type="button" id="alertModalClick" data-toggle="modal" data-target="#myModalAlert" hidden />
<div class="modal" id="myModalAlert" >
    <div class="modal-dialog">
        <div class="modal-content" style="height:200px">
            <div class="modal-header">
                <h4 class="modal-title">Maklumat Sistem</h4>
            </div>
            <div class="modal-body" id="MsgAlert" style="font-size:14px;"></div>
            <div class="modal-footer">
                <div class="container">
                    <div class="row">
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12"></div>
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12">
                          <button type="button" class="btn btn-primary btn-block float-right" data-dismiss="modal" style="width:100%;background:#4f90d6 !important;"><a>Tutup</a></button>
                          </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<input type="button" id="alertModalClick2" data-toggle="modal" data-target="#myModalAlert2" hidden />
<div class="modal" id="myModalAlert2" >
    <div class="modal-dialog">
        <div class="modal-content" style="height:200px">
            <div class="modal-header">
                <h4 class="modal-title">Maklumat Sistem</h4>
            </div>
            <div class="modal-body" id="MsgAlert2" style="font-size:14px;"></div>
            <div class="modal-footer">
                <div class="container">
                    <div class="row">
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12"></div>
                          <div class="col-lg-6 col-md-6 col-xs-12 col-sm-12">
                          <button type="button" class="btn btn-primary btn-block float-right" data-dismiss="modal" id="btnClose" style="width:100%;background:#4f90d6 !important;"><a>Tutup</a></button>
                          </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>



<script type="text/javaScript">

    const iOS = /(iPad|iPhone|iPod)/g.test(navigator.userAgent);

	const reload = () => {window.location = "/homecare/services/install/getAcPreInsResult.do?insNo=${insNo}";}

	$("#salesDt").text($("#salesDt").text() + moment("${installationInfo.salesDt}").format("DD-MM-YYYY"));
	$("#doDt").text($("#doDt").text() + moment("${installationInfo.installDt}").format("DD-MM-YYYY"));

	$(function(){
	    let x = document.querySelector('.bottom_msg_box');
	     x.style.display = "none";
	});

    const optionVal = document.querySelector("#optionVal");

	const refreshOption = () => {
		   const barcodeSection = document.getElementById("barcodeSection"), imageSection =  document.getElementById("imageSection");
		   let value = $("#optionVal option:selected").val();

		   if(!value){
			   barcodeSection.style.display="";
			   imageSection.style.display = "none";
		   }else{
               barcodeSection.style.display="none";
               imageSection.style.display = "";
		   }
	}

	refreshOption();

	optionVal.onchange = e => {
	     refreshOption();
	}


	const openPage1 = () => {
	    document.querySelector("#page2").classList.remove("d-flex");
	    document.querySelector("#page2").style.display = "none";

	    document.querySelector("#page3").classList.remove("d-flex");
	    document.querySelector("#page3").style.display = "none";

	    document.querySelector("#page1").classList.add("d-flex");
	    document.querySelector("#page1").style.display = "";
	}

	const openPage2 = () => {
	    document.querySelector("#page1").classList.remove("d-flex");
	    document.querySelector("#page1").style.display = "none";

	    document.querySelector("#page3").classList.remove("d-flex");
	    document.querySelector("#page3").style.display = "none";

	    document.querySelector("#page2").classList.add("d-flex");
	    document.querySelector("#page2").style.display = "";
	}

	const openPage3 = () => {
	    document.querySelector("#page1").classList.remove("d-flex");
	    document.querySelector("#page1").style.display = "none";

	    document.querySelector("#page2").classList.remove("d-flex");
	    document.querySelector("#page2").style.display = "none";

	    document.querySelector("#page3").classList.add("d-flex");
	    document.querySelector("#page3").style.display = "";

        displayImageUpload(document.getElementById("displayUploadContainer"));
        const installUploadContainer = document.querySelectorAll("#installUploadContainer input");
        const sirimUploadInput = document.querySelector("#sirimUploadContainer input");
        let flag = false;
        if(sirimUploadInput.files[0]){
        	flag=true;
        }

        for(let i = 0; i < installUploadContainer.length; i++){
            if(installUploadContainer[i].files[0]){
                   flag=true;
            }
        }
        if(flag){
            const completeTitle =document.getElementById("completeTitle");
            completeTitle.style.display="";
        }
	}


   $("#btnClose").click(e => {
        e.preventDefault();
        reload();
    });

   $("#btnBackMain").click(e => {
        e.preventDefault();
        window.top.Common.showLoader();
        window.top.location.href = '/homecare/services/install/getAcInstallationInfo.do?insNo=${insNo}';
    });

    $("#btnBackPage1").click(e => {
        e.preventDefault();
        openPage1();
    });

     $("#btnBackPage2").click(e => {
        e.preventDefault();
        openPage2();
    });

    const checkSerial = e => {
        const serial = $("#serialNo").text();
        const serial2 = $("#serialNo2").text();
        const imageSection = document.querySelectorAll("#imageSection input");

        let optionValue = $("#optionVal option:selected").val();

        if(!serial.trim() && !optionValue){
             document.getElementById("MsgAlert").innerHTML =  "Nombor Bersiri Dalaman diperlukan.";
             $("#alertModalClick").click();
            return false;
        }

        if(!serial2.trim() && !optionValue){
            document.getElementById("MsgAlert").innerHTML =  "Nombor Bersiri Luaran diperlukan.";
            $("#alertModalClick").click();
           return false;
       }

        for(let i = 0; i < imageSection.length; i++){
            if(optionValue && !imageSection[i].files[0]){
                document.getElementById("MsgAlert").innerHTML =  "Gambar Nombor Bersiri diperlukan.";
                $("#alertModalClick").click();
                return false;
            }
        }
        return true;
    }

    $("#btnNextPage2").click(e => {
        e.preventDefault();
        openPage2();
//         if(checkSerial()){
// 	        openPage2();
//         }
    });

    $("#btnNextPage3").click(e => {
        e.preventDefault();
        openPage3();
//         if(validationCheck()){
// 	        openPage3();
//         };
    });


    const displayImageUpload = (el) => {
        let uploadImg = document.querySelectorAll('img.install');
        let resetImg = document.getElementById('displayUploadContainer');

        resetImg.innerHTML = "";

        const grid = document.createElement("div");
        grid.classList.add("grid");


        for(let i=0; i < uploadImg.length; i++){
            const gridItem = document.createElement("div");
            gridItem.classList.add("grid-item");
            gridItem.classList.add("card");

            const cardBody = document.createElement("div");
            cardBody.classList.add("card-body");

            const displayImg = document.createElement("img");
             displayImg.classList.add("display");

             if(uploadImg[i].src){
                  displayImg.src = uploadImg[i].src;
                  cardBody.appendChild(displayImg);
                  gridItem.appendChild(cardBody);
                  grid.appendChild(gridItem);
             }
        }

        el.appendChild(grid);

        $('.grid').masonry({
          itemSelector: '.grid-item'
        });
    }


   const addImageUpload = (el, titleName) => {
    	//image upload

    	const title = document.createElement("h5");
        title.innerHTML = "&nbsp;" + titleName + " : ";

        const photoDiv = document.createElement("div");
        photoDiv.style.display = "flex";

        const aElement = document.createElement("a");
        aElement.classList.add("btn");
        aElement.classList.add("btn-tag");
        aElement.classList.add("btn-rounded");
        aElement.classList.add("m-2");
        aElement.classList.add("foto");
        aElement.style.display = "flex";
        aElement.style.alignItems = "center";
        aElement.innerText = "Foto";

        const imageCont = document.createElement("div");
        imageCont.classList.add("p-2");
        imageCont.style.border = "1px solid grey";
        imageCont.style.display = "none";

	    const image = document.createElement("img");
	    image.style.width = "100%";
        image.classList.add("install");

	    const upload = document.createElement("input")
	    upload.type = "file";
        upload.style.display="none";
        upload.accept = ".jpeg,.png,.jpg";

        upload.onchange = (e) => {
            if(e.target.files[0].type !="image/jpeg" && e.target.files[0].type !="image/png"){
            	if(!iOS){
	                document.getElementById("MsgAlert").innerHTML =  "Hanya boleh memuat naik fail imej png dan jpeg";
	                $("#alertModalClick").click();
            	}
            }
            else if(e.target.files[0].size > 2048000){
                document.getElementById("MsgAlert").innerHTML =  "Tidak boleh memuat naik fail imej melebihi 2MB.";
                $("#alertModalClick").click();
            }
            else{
                image.src = URL.createObjectURL(e.target.files[0]);
                imageCont.style.display = "";
            }
        }

        el.appendChild(title);
        el.appendChild(photoDiv);
        photoDiv.appendChild(aElement);
        imageCont.appendChild(image);
        el.appendChild(upload);
        el.appendChild(imageCont)


        aElement.onclick = () => {
            upload.click();
        }

	    //camera
	    const openCamera = document.createElement("button");
	    const screenshot = document.createElement("button");
	    const aElement2 = document.createElement("a");
        aElement2.classList.add("btn");
        aElement2.classList.add("btn-tag");
        aElement2.classList.add("btn-rounded");
        aElement2.style.display = "flex";
        aElement2.style.alignItems = "center";
        aElement2.classList.add("m-2");
        aElement2.classList.add("kamera");
        aElement2.innerText = "Kamera";

        const aElement3 = document.createElement("a");
        aElement3.classList.add("btn");
        aElement3.classList.add("btn-tag");
        aElement3.classList.add("btn-rounded");
        aElement3.style.display = "flex";
        aElement3.style.alignItems = "center";
        aElement3.classList.add("m-2");
        aElement3.classList.add("tangkap");
        aElement3.innerText = "Tangkap";

        openCamera.style.display = "none";
        screenshot.style.display = "none";
        aElement3.style.display = "none";

	    el.insertBefore(openCamera, imageCont);
	    el.insertBefore(screenshot, imageCont);

        photoDiv.appendChild(aElement2);
        photoDiv.appendChild(aElement3);

        aElement2.onclick = () => {
		    navigator.mediaDevices.getUserMedia({video: {facingMode: 'environment'}})
		    .then(s => {
		    	aElement.style.display = "none";
		    	aElement2.style.display = "none";
		    	aElement3.style.display = "flex";
		    	const video = document.createElement("video");
		    	video.autoplay = true;
		    	video.playsInline = true;
		    	video.muted = true;
                video.style.width = "100%";
                video.style.position  = "absolute";
                const vidCont = document.createElement("div")
                vidCont.appendChild(video)
                vidCont.style.position = "relative";
                vidCont.style.overflow = "hidden";
		        const c = document.createElement("canvas")
		        c.style.display = "none";
		        el.appendChild(c);
		    	video.srcObject = s;
		    	video.addEventListener("loadedmetadata", () => {
			    	vidCont.style.height = video.clientHeight + 'px'
		    	})
		        el.insertBefore(vidCont, imageCont);
		        video.play();
		        aElement3.onclick = () => {
		        	aElement3.style.display = "none";
		        	aElement.style.display = "flex";
		        	aElement2.style.display = "flex";
			        c.height = video.videoHeight;
			        c.width = video.videoWidth;
			        const ctx = c.getContext('2d');
			        ctx.drawImage(video, 0, 0, c.width, c.height);
			        image.src = c.toDataURL();
			        c.toBlob(b => {
			        	const f = new File([b], 'upload.jpg');
                        const container = new DataTransfer();
                        container.items.add(f);
                        upload.files = container.files;
                        s.getTracks().forEach(t => t.stop());
                        imageCont.style.display = "";
                        c.remove();
                        vidCont.remove()
			        }, 'image/jpeg')
			    }
		    })
	    }
    }

    addImageUpload(document.getElementById("sirimUploadContainer"), "Sirim");

    for (let i = 0; i < 4; i++) {
        let titleName = "Lampiran "+ (i+1);
	    addImageUpload(document.getElementById("installUploadContainer"), titleName);
    }

    for (let i = 0; i < 2; i++) {
        let titleName = (i==0? "Imbas Kod Bar Dalaman" : "Imbas Kod Bar Luaran");
        addImageUpload(document.getElementById("imageSection"), titleName);
    }

	let resultContainer = document.getElementById('qr-reader-results');
	let html5QrcodeScanner = new Html5Qrcode("qr-reader",{useBarCodeDetectorIfSupported : true});

	let serialObject = {};
	onScanSuccess = (decodedText, decodedResult, seq) => {
        //++countResults
        if(decodedText.length !=18){
        	return;
        }

        if(!serialObject[decodedText]){
        	serialObject[decodedText] =0;
        }

        serialObject[decodedText] +=1;
        if(serialObject[decodedText] > 2){
        	seq.innerText = decodedText;
        	html5QrcodeScanner.stop();
        	html5QrcodeScanner.clear();
        }
	}

    $("#btnScanBarcode").click(e => {
        e.preventDefault();
        html5QrcodeScanner.start({facingMode: 'environment'},  {fps: 200, qrbox: window.innerWidth, formatsToSupport: [ Html5QrcodeSupportedFormats.CODE_128]}
        , (decodedText , decodedResult) => {onScanSuccess(decodedText, decodedResult, document.querySelector("#serialNo"))});
    });

   $("#btnScanBarcodeOutdoor").click(e => {
        e.preventDefault();
        html5QrcodeScanner.start({facingMode: 'environment'},  {fps: 200, qrbox: window.innerWidth, formatsToSupport: [ Html5QrcodeSupportedFormats.CODE_128]}
        , (decodedText , decodedResult) => {onScanSuccess(decodedText, decodedResult, document.querySelector("#serialNo2"))});
    });

	const validationCheck = (e) => {

        const installUploadContainer = document.querySelectorAll("#installUploadContainer input");
        const sirimUploadInput = document.querySelector("#sirimUploadContainer input");

        if(!sirimUploadInput.files[0]){
             document.getElementById("MsgAlert").innerHTML =  "Gambar siri diperlukan untuk melengkapkan pemasangan.";
             $("#alertModalClick").click();
             return false;
        }


        for(let i = 0; i < installUploadContainer.length; i++){
            if(!installUploadContainer[i].files[0]){
                document.getElementById("MsgAlert").innerHTML =  "Empat gambar diperlukan untuk melengkapkan pemasangan.";
                $("#alertModalClick").click();
                return false;
            }
        }

        return true;
	}

    let attachment = 0;
	const insertPreInsComplete = () => {
        const insNo = "${insNo}", serial = $("#serialNo").text() ,  serial2 = $("#serialNo2").text() , remark = document.querySelector("#remark").value;

        fetch("/homecare/services/install/insertPreInsCompleted.do", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                insNo,
                serial,
                serial2,
                attachment,
                remark
            })
        })
        .then(() => {
            document.getElementById("MsgAlert2").innerHTML =  "Pemasangan telah lengkap. Sila tutup paparan ini.";
            $("#alertModalClick2").click();
        })
        .catch(() => {
            document.querySelector("#btnSubmit").style.display="";
            document.querySelector("#btnBackPage2").style.display="";
            document.getElementById("MsgAlert2").innerHTML =  "Pemasangan gagal untuk dihantar.";
            $("#alertModalClick2").click();
        })
	}

    $("#btnSubmit").click(e => {
        e.preventDefault();
        document.querySelector("#btnBackPage2").style.display="none";
        document.querySelector("#btnSubmit").style.display="none";
        fetch("/homecare/services/install/selectInstallationInfo.do?insNo=${insNo}")
        .then(r => r.json())
        .then(resp => {
            if(!resp.dupCheck){
                    const formData = new FormData();
                    const container = new DataTransfer();
                    const imageSection = document.querySelectorAll("#imageSection input");
                    const installUploadContainer = document.querySelectorAll("#installUploadContainer input");
                    const sirimUploadInput = document.querySelector("#sirimUploadContainer input");
                    let uploadFlag = false;

                    const insNo = "${insNo}", serial = $("#serialNo").text() ,  serial2 = $("#serialNo2").text() ;


                    if(sirimUploadInput.files[0]){
                    	uploadFlag=true;
	                    container.items.add(new File([sirimUploadInput.files[0]], 'MOBILE_SVC_${insNo}_' + moment().format("YYYYMMDD")  + '_SIRIM_1.png', {type: sirimUploadInput.files[0].type}))
                    }

                    for(let i = 0; i < installUploadContainer.length; i++){
                        if(installUploadContainer[i].files[0]){
                        	uploadFlag=true;
                        	container.items.add(new File([installUploadContainer[i].files[0]], 'MOBILE_SVC_${insNo}_' + moment().format("YYYYMMDD")  + '_OTHER' + (i+1) +'.png', {type: installUploadContainer[i].files[0].type}))
                        }
                    }

                    const optionValue = $("#optionVal option:selected").val();

                    if(optionValue){
                    	 for(let i = 0; i < imageSection.length; i++){
                    		 if(imageSection[i].files[0]){
                    			   uploadFlag=true;
                    			   container.items.add(new File([imageSection[i].files[0]], 'MOBILE_SVC_${insNo}_' + moment().format("YYYYMMDD")  + '_SERIAL' + (i+1) +'.png', {type: imageSection[i].files[0].type}))
                    		 }
                         }
                    }

                    if(uploadFlag){
	                    $.each(container.files, function(n, v) {
	                              formData.append(n, v);
	                    });

	                    fetch("/homecare/services/install/uploadInsImage.do", {
	                        method: "POST",
	                        body: formData
	                    })
	                    .then(d=>d.json())
	                    .then(r=> {
		                    	if(r.code =="99"){
		                    	     document.getElementById("MsgAlert").innerHTML =  "Pemasangan gagal untuk dihantar. Sila tukar gambar anda.";
		                             $("#alertModalClick").click();
		                             return;
		                    	}

		                        attachment = r.fileGroupKey;
		                        insertPreInsComplete();
	                    })
                    }else{
                    	insertPreInsComplete();
                    }
            }
            else{
            	window.location = "/homecare/services/install/getAcInsComplete.do?insNo=${insNo}";
            }
        });
    })

</script>