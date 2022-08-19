// https://flowbite.com/docs/components/skeleton/
@react.component
let make = (~errorMsg=?) => {
  <div
    role="status"
    className="p-2 space-y-4 max-w-md rounded border-slate-200 divide-y divide-gray-200 animate-pulse dark:divide-slate-500 md:p-6 dark:border-slate-500">
    <div className="flex justify-between items-center">
      {switch errorMsg {
      | None =>
        <div>
          <div className="h-2.5 bg-gray-300 rounded-full dark:bg-gray-600 w-24 mb-2.5" />
          <div className="w-32 h-2 bg-gray-200 rounded-full dark:bg-slate-400" />
        </div>
      | Some(msg) => <p> {msg->React.string} </p>
      }}
      <div className="h-2.5 bg-gray-300 rounded-full dark:bg-slate-400 w-12" />
    </div>
    <div className="flex justify-between items-center pt-4">
      <div>
        <div className="h-2.5 bg-gray-300 rounded-full dark:bg-gray-600 w-24 mb-2.5" />
        <div className="w-32 h-2 bg-gray-200 rounded-full dark:bg-slate-400" />
      </div>
      <div className="h-2.5 bg-gray-300 rounded-full dark:bg-slate-400 w-12" />
    </div>
    <div className="flex justify-between items-center pt-4">
      <div>
        <div className="h-2.5 bg-gray-300 rounded-full dark:bg-gray-600 w-24 mb-2.5" />
        <div className="w-32 h-2 bg-gray-200 rounded-full dark:bg-slate-400" />
      </div>
      <div className="h-2.5 bg-gray-300 rounded-full dark:bg-slate-400 w-12" />
    </div>
    <div className="flex justify-between items-center pt-4">
      <div>
        <div className="h-2.5 bg-gray-300 rounded-full dark:bg-gray-600 w-24 mb-2.5" />
        <div className="w-32 h-2 bg-gray-200 rounded-full dark:bg-slate-400" />
      </div>
      <div className="h-2.5 bg-gray-300 rounded-full dark:bg-slate-400 w-12" />
    </div>
    <div className="flex justify-between items-center pt-4">
      <div>
        <div className="h-2.5 bg-gray-300 rounded-full dark:bg-gray-600 w-24 mb-2.5" />
        <div className="w-32 h-2 bg-gray-200 rounded-full dark:bg-slate-400" />
      </div>
      <div className="h-2.5 bg-gray-300 rounded-full dark:bg-slate-400 w-12" />
    </div>
    <span className="sr-only"> {"Loading..."->React.string} </span>
  </div>
}
