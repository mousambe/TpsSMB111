// ./src/App.tsx

import React, { useState } from 'react';
import Path from 'path';
import uploadFileToBlob, { isStorageConfigured } from './azure-storage-blob';
import getBlobs  from './azure-storage-getblob';

const sleep = (milliseconds: number) => {
  return new Promise(resolve => setTimeout(resolve, milliseconds))
}

const storageConfigured = isStorageConfigured();

const App = (): JSX.Element => {
  // all blobs in container
  const [blobList, setBlobList] = useState<string[]>([]);
  const [blobListhd, setBlobListhd] = useState<string[]>([]);

  // current file to upload into container
  const [fileSelected, setFileSelected] = useState(null);

  // UI/form management
  const [uploading, setUploading] = useState(false);
  const [inputKey, setInputKey] = useState(Math.random().toString(36));

  const onFileChange = (event: any) => {
    // capture file into state
    setFileSelected(event.target.files[0]);
  };



  

  const onFileUpload = async () => {
    // prepare UI
    setUploading(true);

    // *** UPLOAD TO AZURE STORAGE ***
    const blobsInContainer: string[] = await uploadFileToBlob(fileSelected);
    
    // prepare UI for results
    setBlobList(blobsInContainer);

    // reset state/form
    setFileSelected(null);
    setUploading(false);
    setInputKey(Math.random().toString(36));
  };



  // display form
  const DisplayForm = () => (
    <div>
      <input type="file" onChange={onFileChange} key={inputKey || ''} />
      <button type="submit" onClick={onFileUpload}>
        Upload!
          </button>
    </div>
  )

  const DisplayAmelioration = () => (
    <div>
        <p>Super-Resolution Image in process, please wait ....</p>
    </div>
  );


  

  // display file name and image
  const DisplayImagesFromContainer = () => (
    <div>
      <h2>Uploaded Image</h2>
      <ul>
        {blobList.map((item) => {
          return (
            <li key={item}>
              <div>
                {Path.basename(item)}
                <br />
                <img src={item} alt={item}  />
              </div>
            </li>
          );
        })}
      </ul>
    </div>
  );

  const ongetBlobs = async () => {
    await sleep(20000);
    const blobsInContainerhd: string[] = await getBlobs(null);
    setBlobListhd(blobsInContainerhd);
  }
  ongetBlobs();

  const DisplayImagesFromhdContainer = () => (
    <div>
      <h2>Super-Resolution Image</h2>
      <ul>
        {blobListhd.map((item) => {
          return (
            <li key={item}>
              <div>
                {Path.basename(item)}
                <br />
                <img src={item} alt={item} />
              </div>
            </li>
          );
        })}
      </ul>
    </div>
  );

  return (
    <div>
      <h1>Azure function using python library ddddsr to make image super-resolution</h1>
      {storageConfigured && !uploading && DisplayForm()}
      {storageConfigured && uploading && <div>Uploading</div>}
      <hr />
      {storageConfigured && blobList.length > 0 && DisplayImagesFromContainer()}
      {storageConfigured && blobList.length > 0 && DisplayAmelioration()}

      {!storageConfigured && <div>Storage is not configured.</div>}
      <hr />
      {storageConfigured && blobListhd.length > 0 && DisplayImagesFromhdContainer()}

    
    </div>
    
  );
};

export default App;


